module UserHelper
  def is_current_user?(user_id)
    Current.user.id == user_id
  end

  def self.full_name(user)
    "#{user.first_name} #{user.last_name}"
  end
end
