module NotesHelper
  def inline_style
    Rails.application.assets.find_asset('note_pdf/note.css').to_s.html_safe
  end
end
