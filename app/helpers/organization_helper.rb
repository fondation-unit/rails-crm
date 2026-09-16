module OrganizationHelper
    def self.status_class(org)
        Organization::STATUS_TABLE_CLASSES[org.status.to_sym]
    end

    def self.generate_orga_fields(exp, user_id)
        orga_fields = {
            name: exp['Etablissement'],
            zip_code: exp['Code Postal'].present? ? exp['Code Postal'] : nil,
            city: exp['Ville'].present? ? exp['Ville'] : nil,
            user_id: user_id,
            status: 0,
        }
        orga_fields
    end

    def self.update_or_create(exp, user_id)
        orga_fields = self.generate_orga_fields(exp, user_id)

        orga = Organization.find_by(name: exp['Etablissement'])
        (orga) ? orga.update!(orga_fields) : Organization.create!(orga_fields)
    end
end
