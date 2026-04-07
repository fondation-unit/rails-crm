module OrganizationHelper
  def self.status_class(org)
    Organization::STATUS_TABLE_CLASSES[org.status.to_sym]
  end
end
