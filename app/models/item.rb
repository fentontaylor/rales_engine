class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :merchant_id

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.most_revenue(qty)
    qty = qty.to_i
    find_by_sql(
      "SELECT i.*, SUM(ii.quantity * ii.unit_price) as total_revenue " +
        "FROM items i " +
        "INNER JOIN invoice_items ii ON i.id = ii.item_id " +
        "INNER JOIN invoices inv ON inv.id = ii.invoice_id " +
        "INNER JOIN transactions t ON inv.id = t.invoice_id " +
        "WHERE t.result = 'success' " +
        "GROUP BY i.id " +
        "ORDER BY total_revenue DESC " +
        "LIMIT #{qty}")
  end
end
