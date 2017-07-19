module NoteHelper
  def inline_style
    Rails.application.assets.find_asset('note_pdf/note.css').to_s.html_safe
  end

  def note_type(type)
    case type
    when :credit_note
      'Creditnota'
    when :income_note
      'Inkomstennota'
    else
      'Factuur'
    end
  end
end
