class InvoiceController < ApplicationController
  def index; end

  def show
    @invoice = Invoice.first

    respond_to do |format|
      format.html { render layout: 'paper' }
      format.pdf { send_data(@invoice.generated_pdf.data, filename: 'Factuur.pdf') }
    end
  end

  def new; end

  def create
    @invoice = Invoice.new

    Dir.mktmpdir do |dir|
      input_file = Rails.root.join('factuur', 'paper.html')
      output_file = "#{dir}/output.pdf"
      command = '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --headless --disable-gpu'

      `#{command} --print-to-pdf=#{output_file} file://#{input_file}`

      file_contents = File.binread(output_file)
      @invoice.generated_pdf = BSON::Binary.new(file_contents)
    end

    @invoice.save
  end
end
