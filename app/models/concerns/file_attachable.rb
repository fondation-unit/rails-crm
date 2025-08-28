# frozen_string_literal: true

require "vips"

module FileAttachable
  extend ActiveSupport::Concern

  ALLOWED_MIME_TYPES = %w[image/jpeg image/pjpeg image/png]
  MAX_FILE_SIZE = 1.megabyte

  included { class_attribute :attached_file_name }

  class_methods do
    def attaches_one(name)
      self.attached_file_name = name

      validate :validate_mime_type, if: -> { send(name).attached? }
      validate :validate_file_size, if: -> { send(name).attached? }

      before_destroy :delete_attached_file, if: -> { send(name).attached? }
    end
  end

  private

  def validate_mime_type
    file = send(self.class.attached_file_name)
    return unless file.attached? && file.blob.present?

    unless ALLOWED_MIME_TYPES.include?(file.blob.content_type)
      errors.add(
        self.class.attached_file_name,
        "must be " + ALLOWED_MIME_TYPES.join(", ")
      )
    end
  end

  def validate_file_size
    file = send(self.class.attached_file_name)
    return unless file.attached?

    if file.blob.byte_size > MAX_FILE_SIZE
      errors.add(self.class.attached_file_name, "size too large")
    end
  end

  def delete_attached_file
    attachment = send(self.class.attached_file_name)
    attachment.purge if attachment.attached?
  end
end
