module Crm
  class Member < ApplicationRecord
    include NameNormalization
    include Crm::FullTextSearchable

    has_many :notes, as: :notable

    has_and_belongs_to_many :member_types, join_table: "member_types_members"
    has_and_belongs_to_many :organizations, join_table: "members_organizations"
    has_and_belongs_to_many :investments, join_table: "members_investments"
    has_and_belongs_to_many :levels, join_table: "members_levels"
    has_and_belongs_to_many :disciplines, join_table: "members_disciplines"

    STATUS_TABLE_MEMBER_CLASSES = {
      a_contacter: "table-info",
      contacte: "table-success",
      rappel: "table-secondary",
      refus: "table-danger",
      inconnu: "table-warning"
    }

    validates :first_name, :last_name, presence: true
    validates :email_address,
              uniqueness: true,
              format: {
                with: URI::MailTo::EMAIL_REGEXP
              }
    validates :phone_number,
              telephone_number: {
                country: "FR",
                message: "Numéro de téléphone invalide"
              },
              allow_blank: true

    normalize_user_names :first_name, :last_name

    before_save :set_phone_number
    enum :status, self::STATUS_TABLE_MEMBER_CLASSES.keys

    default_scope { includes(%i[member_types investments]) }

    def organizations_names
      organizations.collect { |org| { name: org.name, id: org.id } }
    end

    def member_types_names
      member_types.collect { |type| { name: type.name, id: type.id } }
    end

    def investments_names
      investments.collect { |type| { name: type.name } }
    end

    def set_phone_link
      phone_object = TelephoneNumber.parse(phone_number, :fr)
      self.phone_number = phone_object.e164_number
    end

    def has_organizations?
      organizations.exists?
    end

    private

    def set_phone_number
      phone_object = TelephoneNumber.parse(phone_number, :fr)
      self.phone_number = phone_object.international_number
    end
  end
end

# == Schema Information
#
# Table name: members
#
#  id                    :bigint           not null, primary key
#  comex                 :boolean
#  copil                 :boolean
#  decisionnaire         :boolean
#  email_address         :string           not null
#  first_name            :string           not null
#  gender                :string
#  invest                :boolean
#  last_name             :string           not null
#  linkedin              :string
#  linkedin_connected    :boolean
#  newsletter_ressources :boolean
#  phone_number          :string
#  position              :string
#  principal             :boolean
#  search_vector         :tsvector
#  status                :integer          default("a_contacter")
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_members_on_email_address  (email_address) UNIQUE
#  index_members_on_search_vector  (search_vector) USING gin
#
