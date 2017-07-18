class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :destroy, :unarchive]

  # GET /invoices
  # GET /invoices.json
  def index
    @archived = params[:archived].present?
    if @archived
      @invoices = Invoice.deleted.order(created_at: :desc)
    else
      @invoices = Invoice.all.order(created_at: :desc)
    end
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
    p invoice_params[:costs]

    respond_to do |format|
      if @invoice.save
        flash[:success] = 'Factuur werd aangemaakt.'
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
      flash[:success] = 'Factuur werd verwijderd.'
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end

  # POST /invoices/1/unarchive
  def unarchive
    @invoice.restore
    redirect_back(fallback_location: invoices_url, notice: 'Factuur werd hersteld.')
  end

  def preview
    render(
      :invoice_pdf,
      layout: 'paper',
      locals: {
        base_url: request.base_url,
        invoice: Invoice.first,
        contact: Contact.first
      }
    )
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invoice
    @invoice = Invoice.unscoped.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invoice_params
    params.require(:invoice).permit(:contact, :note_type, costs_attributes: [:amount, :description, :date])
  end
end
