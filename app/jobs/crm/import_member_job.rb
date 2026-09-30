module Crm
  class ImportMemberJob
    include Sidekiq::Job

    def perform(user_id, row)
      user = User.find(user_id)
      member = Member.find_or_initialize_by(email_address: row["email_address"])

      new_member = member.new_record?
      investments = investment_ids(row)

      member.update!(
        first_name: Crm::MemberHelper.utf_decode(row["first_name"]),
        last_name: Crm::MemberHelper.utf_decode(row["last_name"]),
        email_address: row["email_address"],
        phone_number: nil,
        copil: yes?(row["copil (oui/non)"]),
        comex: yes?(row["comex (oui/non)"]),
        newsletter_ressources: yes?(row["newsletter_ressources (oui/non)"]),
        invest: investments.any?,
        investment_ids: investments
      )

      if row["Etablissement"].present?
        etab = row["Etablissement"]
        orga = Organization.find_or_initialize_by(name: etab)

        orga.update!(
          name: etab,
          zip_code: row["Code Postal"].presence,
          city: row["Ville"].presence,
          user_id: user.id,
          status: row["Statut"].presence&.to_i || 0
        )

        if !member.has_organizations?
          sql =
            "INSERT INTO members_organizations (member_id, organization_id) VALUES (#{member.id}, #{orga.id})"
          ActiveRecord::Base.connection.execute(sql)
        end
      end

      if row["Notes"].present? &&
          !Note.find_by(
            user_id: user.id,
            notable_id: member.id,
            notable_type: "Member"
          ).present?
        member.notes.create!(
          user_id: user.id,
          content: Crm::MemberHelper.utf_decode(row["Notes"])
        )
      end

      if new_member
        ReferentMailer.with(member: member).investments_email.deliver_later
      end
    end

    private

    def investment_ids(row)
      {
        "Donner son contenu (oui/non)" => 1,
        "Participer a la relecture (oui/non)" => 2,
        "Tester les ressources (oui/non)" => 3,
        "Identifier les besoins/manques (oui/non)" => 4
      }.filter_map { |column, id| id if yes?(row[column]) }
    end

    def yes?(value)
      value.to_s.casecmp("oui").zero?
    end
  end
end
