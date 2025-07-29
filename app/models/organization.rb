class Organization < ApplicationRecord
  include FileAttachable

  has_and_belongs_to_many :members, join_table: "members_organizations"

  has_one_attached :logo do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
    attachable.variant :medium,
                       resize_to_limit: [600, 400],
                       format: :webp,
                       saver: {
                         subsample_mode: "on",
                         strip: true,
                         interlace: true,
                         quality: 85
                       }
  end
  attaches_one :logo # Validate the file through FileAttachable

  attr_accessor :remove_logo

  validates :name, presence: true

  before_save :purge_logo_if_wanted

  scope :ordered, -> { order(name: "asc") }

  private

  def purge_logo_if_wanted
    logo.purge if ActiveModel::Type::Boolean.new.cast(remove_logo)
  end
end

# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  address    :string
#  city       :string
#  lat        :float
#  lng        :float
#  name       :string           not null
#  zip_code   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
