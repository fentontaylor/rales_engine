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
end
