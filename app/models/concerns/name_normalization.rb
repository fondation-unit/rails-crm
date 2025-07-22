module NameNormalization
  extend ActiveSupport::Concern

  USER_NAME_REGEX = /[^a-zA-ZéÉèÈëËàÀùÙäÄïÏöÖüÜâÂêÊîÎôÔûÛ\s-]/i
  NAME_NORMALIZER = ->(name) { name.to_s.gsub(USER_NAME_REGEX, "").patronize }

  class_methods do
    def normalize_user_names(*attrs)
      attrs.each { |attr| normalizes attr, with: NAME_NORMALIZER }
    end
  end
end
