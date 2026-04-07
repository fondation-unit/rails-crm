class Note < ApplicationRecord
  belongs_to :user
  belongs_to :member

  has_rich_text :content

  validates_associated :user, :member

  scope :ordered, -> { order(created_at: "desc") }
  scope :for_member,
        ->(current_user, member) do
          where(user: current_user, member: member)
            .or(Note.where(member: member, public: true))
            .includes(:user)
            .distinct
            .ordered
        end
end

# == Schema Information
#
# Table name: notes
#
#  id           :bigint           not null, primary key
#  contact_type :string
#  public       :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  member_id    :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_notes_on_member_id  (member_id)
#  index_notes_on_user_id    (user_id)
#
