class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.most_revenue(limit)
    find_by_sql("SELECT m.*, sum(ii.unit_price * ii.quantity) as total_revenue " +
            "FROM merchants m " +
            "INNER JOIN invoices i ON m.id = i.merchant_id " +
            "INNER JOIN invoice_items ii ON i.id = ii.invoice_id " +
            "INNER JOIN transactions t ON i.id = t.invoice_id " +
            "WHERE t.result = 'success' " +
            "GROUP BY m.id " +
            "ORDER BY total_revenue DESC " +
            "LIMIT #{limit}")

    # Merchant.joins(invoices: :transactions)
    #   .joins(:invoice_items)
    #   .where(transactions: {result: :success})
    #   .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue")
    #   .group("merchants.id")
    #   .order("total_revenue desc")
    #   .limit(limit)
  end

  def self.revenue(date)
    sql = "SELECT SUM(ii.quantity * ii.unit_price) as total_revenue " +
            "FROM invoices i " +
            "INNER JOIN invoice_items ii ON i.id = ii.invoice_id " +
            "INNER JOIN transactions t ON t.invoice_id = i.id " +
            "WHERE date(i.created_at) = '#{date}' " +
              "AND t.result = 'success'"

    result = ActiveRecord::Base.connection.execute(sql)
    result.first
  end

  def self.find_by_lower_name(name)
    where('lower(name) like ?', "%#{name.downcase}%").first  
  end

  def favorite_customer
    sql = "SELECT c.*, count(*) as num_transactions " +
            "FROM customers c " +
            "INNER JOIN invoices i ON c.id = i.customer_id " +
            "INNER JOIN transactions t ON t.invoice_id = i.id " +
            "INNER JOIN merchants m ON i.merchant_id = m.id " +
            "WHERE m.id = #{self.id} AND t.result = 'success' " +
            "GROUP BY c.id " +
            "ORDER BY num_transactions DESC, c.id " +
            "LIMIT 1"

    result = ActiveRecord::Base.connection.execute(sql)
    Customer.find(result.first['id'])
  end
end
