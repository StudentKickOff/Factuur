class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all

    logger.debug(request.base_url)
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @pdf_path = invoice_path(id: @invoice.id, format: :pdf)

    respond_to do |format|
      format.html
      format.json
      format.pdf { send_data(@invoice.generated_pdf.data, filename: 'factuur.pdf', type: :pdf, disposition: :inline) }
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)


    # Temporary directory, no need to store all this
    Dir.mktmpdir do |dir|
      # TODO: Put this in a config
      command = 'electron-pdf'
      input_file = "#{dir}/input.html"
      output_file = "#{dir}/output.pdf"

      s = render_to_string 'invoice/invoice_pdf', layout: 'paper'
      File.write(input_file, s)

      `#{command} #{input_file} #{output_file}`

      file_contents = File.binread(output_file)
      @invoice.generated_pdf = BSON::Binary.new(file_contents)

      FileUtils.cp(output_file, Rails.root.join('output.pdf'))
    end

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invoice_params
    params.require(:invoice).permit(:description, :generated_pdf)
  end
end
