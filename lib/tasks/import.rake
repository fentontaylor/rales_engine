namespace :import do
  desc 'Import data from CSV files'

  require 'csv'

  task customers: :environment do
    CSV.foreach('./db/data/customers.csv', headers: true) do |row|
      Customer.create(row.to_h)
    end
  end

  task merchants: :environment do
    CSV.foreach('./db/data/merchants.csv', headers: true) do |row|
      Merchant.create(row.to_h)
    end
  end

  task items: :environment do
    CSV.foreach('./db/data/items.csv', headers: true) do |row|
      Item.create(row.to_h)
    end
  end

  task invoices: :environment do
    CSV.foreach('./db/data/invoices.csv', headers: true) do |row|
      Invoice.create(row.to_h)
    end
  end

  task invoice_items: :environment do
    CSV.foreach('./db/data/invoice_items.csv', headers: true) do |row|
      InvoiceItem.create(row.to_h)
    end
  end

  task transactions: :environment do
    CSV.foreach('./db/data/transactions.csv', headers: true) do |row|
      Transaction.create(
        invoice_id: row[1],
        credit_card_number: row[2],
        result: row[4],
        created_at: row[5],
        updated_at: row[6])
    end
  end
end
