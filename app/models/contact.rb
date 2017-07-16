class Contact
  include Mongoid::Document

  embeds_one :address

  has_many :invoices

  field :name, type: String

  def to_s
    name
  end
end

class Address
  include Mongoid::Document

  field :street, type: String
  field :zip_code, type: String
  field :city, type: String
  field :country, type: String

  embedded_in :contact
end
