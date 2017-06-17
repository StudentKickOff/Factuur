module InvoiceHelper
  def inline_style
    Rails.application.assets.find_asset('invoice_pdf/invoice.css').to_s.html_safe
  end
end
