json.extract! invoice, :id, :description, :generated_pdf, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
