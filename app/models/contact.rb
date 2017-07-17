class Contact
  include Mongoid::Document

  embeds_one :address

  has_many :invoices

  field :name, type: String
  field :vatnumber, type: String

  validates_presence_of :name, :vatnumber

  def to_s
    name
  end

end

class Address
  include Mongoid::Document

  field :beneficiary, type: String
  field :street, type: String
  field :zip_code, type: String
  field :city, type: String
  field :country, type: String

  validates_presence_of :street, :zip_code, :city, :country

  embedded_in :contact
end
