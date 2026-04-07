class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user

  has_rich_text :content

  validates_associated :user

  scope :ordered, -> { order(created_at: "desc") }
  scope :for_notable,
        ->(current_user, member) do
          where(user: current_user, notable: member)
            .or(Note.where(notable: member, public: true))
            .includes(:user)
            .distinct
            .ordered
        end
end

# == Schema Information
#
# Table name: notes
#
#  id           :integer          not null, primary key
#  contact_type :string
#  notable_type :string           not null
#  public       :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  notable_id   :integer          not null
#  user_id      :integer
#
# Indexes
#
#  index_notes_on_notable  (notable_type,notable_id)
#  index_notes_on_user_id  (user_id)
#
