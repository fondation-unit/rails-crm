module Crm
module MemberHelper
  def self.status_class(member)
    Member::STATUS_TABLE_MEMBER_CLASSES[member.status.to_sym]
  end

  def self.full_name(member)
    "#{member.first_name} #{member.last_name}"
  end

  def self.utf_decode(string)
    "#{string.force_encoding("utf-8").strip}"
  end
end
end
