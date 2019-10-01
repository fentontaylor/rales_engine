class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id
  validates_presence_of :item_id
  validates_presence_of :quantity
  validates_presence_of :unit_price
end
