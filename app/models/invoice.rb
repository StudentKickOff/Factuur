class Invoice
  include Mongoid::Document
  # created_at, updated_at
  include Mongoid::Timestamps

  # Invoices should be immutable and never changed.
  before_validation { false if changed? && persisted? }

  field :description, type: String
  field :generated_pdf, type: BSON::Binary
end
