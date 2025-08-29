module NoteHelper
  def note_excerpt(content)
    content.to_plain_text.truncate(100)
  end
end
