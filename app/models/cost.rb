class Cost
  include Mongoid::Document

  field :description, type: String
  field :date,        type: Date,       default: -> { Date.today }
  field :amount,      type: Integer,    default: 1
  field :price,       type: BigDecimal, default: 0

  validates :description, :date, :amount, :price, presence: true
end
