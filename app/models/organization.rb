class Organization < ApplicationRecord
  include FileAttachable
  include FullTextSearchable

  STATUS_TABLE_CLASSES = {
    "a_contacter": "table-info",
    "contacte": "table-success",
    "rappel": "table-secondary",
    "refus": "table-danger",
    "inconnu": "table-warning"
  }

  has_many :notes, as: :notable

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

  enum :status, self::STATUS_TABLE_CLASSES.keys

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
#  id                 :bigint           not null, primary key
#  address            :string
#  city               :string
#  lat                :float
#  linkedin           :string
#  linkedin_connected :boolean          default(FALSE), not null
#  lng                :float
#  name               :string           not null
#  search_vector      :tsvector
#  status             :integer
#  type_orga          :string
#  zip_code           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_organizations_on_name           (name) UNIQUE
#  index_organizations_on_search_vector  (search_vector) USING gin
#
