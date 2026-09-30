module Crm
  module UserHelper
    def self.full_name(user)
      "#{user.first_name} #{user.last_name}"
    end
  end
end
