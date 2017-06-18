class InvoiceController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @pdf_path = invoice_path(id: @invoice.id, format: :pdf)

    respond_to do |format|
      format.html
      format.pdf { send_data(@invoice.generated_pdf.data, filename: 'factuur.pdf', type: :pdf, disposition: :inline) }
    end
  end

  def new; end

  def create
    @invoice = Invoice.new

    # Temporary directory, no need to store all this
    Dir.mktmpdir do |dir|
      output_file = "#{dir}/output.pdf"
      # TODO: Put this in a config
      command = '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --headless --disable-gpu'

      `#{command} --print-to-pdf=#{output_file} http://localhost:3000#{invoice_preview_path}`

      file_contents = File.binread(output_file)
      @invoice.generated_pdf = BSON::Binary.new(file_contents)

      FileUtils.cp(output_file, Rails.root.join('output.pdf'))
    end

    @invoice.save
  end

  def generate
    render :invoice_pdf, layout: 'paper'
  end
end
