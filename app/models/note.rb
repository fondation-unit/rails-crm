class Note < ApplicationRecord
  belongs_to :user
  belongs_to :member

  has_rich_text :content

  enum :contact_type, %i[email phone chat show other]

  validates_associated :user, :member

  scope :ordered, -> { order(created_at: "desc") }

  def self.getNotesForUsers(params)
    Note
      .includes("user")
      .where(user_id: Current.user.id, member_id: params[:member_id])
      .or(
        Note
          .where(member_id: params[:member_id], public: true)
          .where.not(user_id: Current.user.id)
      )
      .ordered
  end

  def showDate
    self.created_at.strftime("%d-%m-%Y %H:%M")
  end
end

# == Schema Information
#
# Table name: notes
#
#  id           :integer          not null, primary key
#  contact_type :string
#  content      :text
#  public       :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  member_id    :integer
#  user_id      :integer
#
# Indexes
#
#  index_notes_on_member_id  (member_id)
#  index_notes_on_user_id    (user_id)
#
