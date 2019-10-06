class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id
  validates_presence_of :item_id
  validates_presence_of :quantity
  validates_presence_of :unit_price

  belongs_to :item
  belongs_to :invoice

  def self.search(search_params, multiple: false)
    if search_params['unit_price']
      search_params['unit_price'] = search_params['unit_price'].to_f * 100
    end
    inv_items = InvoiceItem.where( search_params )
    multiple ? inv_items : inv_items.first
  end

  def dollar_price_as_string
    digits = self.unit_price.to_s.split('')
    cents = digits.pop(2)
    digits.join + '.' + cents.join
  end
end
