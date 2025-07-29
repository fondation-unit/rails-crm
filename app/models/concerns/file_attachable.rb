# frozen_string_literal: true

module FileAttachable
  extend ActiveSupport::Concern

  ALLOWED_MIME_TYPES = %w[image/jpeg image/pjpeg image/png]

  included { class_attribute :attached_file_name }

  class_methods do
    def attaches_one(name)
      self.attached_file_name = name

      validate :validate_mime_type, if: -> { send(name).attached? }

      before_create :detect_file_type, if: -> { send(name).attached? }
      before_destroy :delete_attached_file, if: -> { send(name).attached? }
    end
  end

  private

  def validate_mime_type
    unless ALLOWED_MIME_TYPES.include?(logo.blob.content_type)
      errors.add(:logo, "must be a JPEG or PNG image")
      logo.purge
    end
  end

  def delete_attached_file
    file.purge
  end
end
