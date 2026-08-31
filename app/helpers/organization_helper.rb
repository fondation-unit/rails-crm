module OrganizationHelper
  def self.status_class(org)
    Organization::STATUS_TABLE_CLASSES[org.status.to_sym]
  end

  def self.generate_orga_fields(exp)
    orga_field = [
      name: exp[4],
      address: exp[6].present? ? exp[6] : nil,
      zip_code: exp[5].present? ? exp[5] : nil,
    ]
  end

  def self.update_or_create(exp)
    orga_fields = self.generate_orga_fields(exp)
    orga = Organization.find_by(name: exp[4])
    if(orga)
      orga.update!(orga_fields)
    else
      Organization.create!(orga_fields)
    end
      
  end 
end
