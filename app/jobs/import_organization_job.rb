class ImportOrganizationJob
    include Sidekiq::Job

    def perform(user_id, row)
        user = User.find(user_id)

        orga = Organization.find_or_initialize_by(name: row['Etablissement'])
        newOrga = orga.new_record?
        orga.update!(
            name: row['Etablissement'],
            zip_code: row['Code Postal'].present? ? row['Code Postal'] : nil,
            city: row['Ville'].present? ? row['Ville'] : nil,
            user_id: user.id,
            status: row['Statut'].present? ? row['Statut'] : 0,
        )

        if row['Notes'].present? &&
               !Note.find_by(
                   user_id: user.id,
                   notable_id: orga.id,
                   notable_type: 'Organization',
               ).present?
            orga.notes.create!(user_id: user.id, content: decode(row['Notes']))
        end
        if newMember
            ReferentMailer.with(member: member).investments_email.deliver_later
        end
    end

    private

    def investment_ids(row)
        {
            'Donner son contenu (oui/non)' => 1,
            'Participer a la relecture (oui/non)' => 2,
            'Tester les ressources (oui/non)' => 3,
            'Identifier les besoins/manques (oui/non)' => 4,
        }.filter_map { |column, id| id if yes?(row[column]) }
    end

    def yes?(value)
        value.to_s.casecmp('oui').zero?
    end

    def checkLienOrgaMember(member)
        member.organizations.exists?
    end

    def decode(value)
        MemberHelper.utf_decode(value)
    end
end
