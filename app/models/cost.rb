class Cost
  include Mongoid::Document

  field :description, type: String
  field :date,        type: Date,       default: -> { Date.today }
  field :amount,      type: BigDecimal, default: 0

  validates :description, :date, :amount, presence: true
end
