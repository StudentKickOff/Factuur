class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all.order(created_at: :desc)

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

    respond_to do |format|
      if @invoice.save
        flash[:success] = 'Invoice was successfully created.'
        format.html { redirect_to @invoice }
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
      flash[:success] = 'Invoice was successfully destroyed.'
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  def preview
    render(
      :invoice_pdf,
      layout: 'paper',
      locals: {
        base_url: request.base_url,
        netto: 100
      }
    )
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
