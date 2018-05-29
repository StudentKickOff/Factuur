class Cost
  include Mongoid::Document
  include Mongoid::Enum

  enum :vat, [:v0, :v6, :v21], default: :v21

  field :description, type: String
  field :amount,      type: Integer,    default: 1
  field :price,       type: BigDecimal, default: 0

  validates :description, :amount, :price, :vat, presence: true

  def self.vat_i18n_select_options
    Cost::VAT.map do |k, _|
      [I18n.t("mongoid.enums.#{model_name.i18n_key}.vat.#{k}"), k]
    end
  end
end
