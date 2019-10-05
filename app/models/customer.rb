class Customer < ApplicationRecord
  validates_presence_of :first_name
  validates_presence_of :last_name

  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items

  def favorite_merchant
    Merchant.find_by_sql(
      "SELECT id, name, created_at, updated_at from " +
        "(SELECT m.*, COUNT(*) as num_transactions FROM customers c " +
        "INNER JOIN invoices i ON c.id = i.customer_id " +
        "INNER JOIN transactions t ON t.invoice_id = i.id " +
        "INNER JOIN merchants m ON i.merchant_id = m.id " +
        "WHERE t.result = 'success' AND c.id = #{self.id} " +
        "GROUP BY m.id " +
        "ORDER BY num_transactions DESC " +
        "LIMIT 1) temp"
    ).first
  end
end
