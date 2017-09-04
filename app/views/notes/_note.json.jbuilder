json.extract! note, :id, :description, :generated_pdf, :created_at, :updated_at
json.url note_url(note, format: :json)
