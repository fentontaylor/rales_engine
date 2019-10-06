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
  end

  def self.revenue(date)
    ActiveRecord::Base.connection.execute(
      "SELECT SUM(ii.quantity * ii.unit_price) as total_revenue " +
        "FROM invoices i " +
        "INNER JOIN invoice_items ii ON i.id = ii.invoice_id " +
        "INNER JOIN transactions t ON t.invoice_id = i.id " +
        "WHERE date(i.created_at) = '#{date}' " +
          "AND t.result = 'success'"
    ).first
  end

  def favorite_customer
    Customer.find_by_sql(
      "SELECT c.*, count(*) as num_transactions " +
        "FROM customers c " +
        "INNER JOIN invoices i ON c.id = i.customer_id " +
        "INNER JOIN transactions t ON t.invoice_id = i.id " +
        "INNER JOIN merchants m ON i.merchant_id = m.id " +
        "WHERE m.id = #{self.id} AND t.result = 'success' " +
        "GROUP BY c.id " +
        "ORDER BY num_transactions DESC, c.id " +
        "LIMIT 1"
    ).first
  end

  def self.search(search_params, multiple: false)
    merchants = case search_params.keys.first
    when 'id', 'created_at', 'updated_at'
      Merchant.where( search_params )
    when 'name'
      Merchant.name_search( search_params['name'] )
    end
    multiple ? merchants : merchants.first
  end

  def self.name_search(name)
    where('lower(name) like ?', "%#{name.downcase}%")
  end

  def self.date_search(args)
    args.transform_values! { |v| DateTime.xmlschema(v) }
    where(args).first
  end
end
