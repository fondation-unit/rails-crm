module NameNormalization
  extend ActiveSupport::Concern

  USER_NAME_REGEX = /[^\p{Letter}\s-]/u
  NAME_NORMALIZER =
    lambda do |name|
      name.to_s.gsub(USER_NAME_REGEX, "").split("-").map(&:titleize).join("-")
    end

  class_methods do
    def normalize_user_names(*attrs)
      attrs.each { |attr| normalizes attr, with: NAME_NORMALIZER }
    end
  end
end
