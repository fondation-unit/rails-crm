class Note < ApplicationRecord
  belongs_to :user
  belongs_to :member

  has_rich_text :content

  validates_associated :user, :member

  scope :ordered, -> { order(created_at: "desc") }
  scope :for_user,
        ->(current_user, member) do
          where(user: current_user, member: member)
            .or(
              where(member: member)
                .where(member: member, public: true)
                .where.not(user: current_user)
            )
            .includes(:user)
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
