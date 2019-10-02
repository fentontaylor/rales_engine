class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.most_revenue(limit)
    Merchant.joins(:invoice_items)
      .joins(:transactions)
      .select("merchants.*, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
      .where("transactions.result = ?", 'success')
      .group("merchants.id")
      .order("total_revenue desc")
      .limit(limit)
  end
end
