class ImportMemberJob
  include Sidekiq::Job

  def perform(user_id, row)
    user = User.find(user_id)
    member = Member.find_or_initialize_by(email_address: row["email_address"])

    newMember = member.new_record?

    member.update!(
      first_name: decode(row["first_name"]),
      last_name: decode(row["last_name"]),
      email_address: row["email_address"],
      phone_number: nil,
      copil: yes?(row["copil (oui/non)"]),
      comex: yes?(row["comex (oui/non)"]),
      newsletter_ressources: yes?(row["newsletter_ressources (oui/non)"]),
      invest: investment_ids(row).any?,
      investment_ids: investment_ids(row)
    )

    if row["Etablissement"].present?
      orga = Organization.find_or_initialize_by(name: row["Etablissement"])

      orga.update!(
        name: row["Etablissement"],
        zip_code: row["Code Postal"].present? ? row["Code Postal"] : nil,
        city: row["Ville"].present? ? row["Ville"] : nil,
        user_id: user.id,
        status: row["Statut"].present? ? row["Statut"] : 0
      )

      if !checkLienOrgaMember(member)
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
      member.notes.create!(user_id: user.id, content: decode(row["Notes"]))
    end
    if newMember
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

  def checkLienOrgaMember(member)
    member.organizations.exists?
  end

  def decode(value)
    MemberHelper.utf_decode(value)
  end
end
