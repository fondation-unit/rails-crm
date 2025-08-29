module UserHelper
  def is_current_user?(user_id)
    Current.user.id === user_id
  end
end
