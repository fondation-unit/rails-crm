module MemberHelper
  def self.full_name(member)
    "#{member.first_name} #{member.last_name}"
  end
end
