module Crm
  module NoteHelper
    def note_excerpt(content)
      content.to_plain_text.truncate(100)
    end

    def note_contact_type(note)
      note.contact_type.present? ? I18n.t("notes.#{note.contact_type}") : ""
    end
  end
end
