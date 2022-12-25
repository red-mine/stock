namespace :stocks do
  desc "fetch"
  task fetch: :environment do
  end

  desc "find"
  task :find, [:code, :date] => :environment do |task, args|
    p Stock.find_by(code: args.code, date: args.date)
  end

  desc "dump"
  task dump: :environment do
    Stock.all.each do |stock|
      p stock
    end
  end

  desc "import"
  task :import, [:stock] => :environment do |task, args|
    file_path = "C:\\new_tdx\\vipdoc\\sz\\lday\\" + args.stock + ".day"
    file = File.open(file_path)
    while file.eof == false
      file_data = file.read(32)
      string = file_data.unpack("H*")[0]

      date = string[0,8]
      real_date = date[6..7] + date[4..5] + date[2..3] + date[0..1]
      real_date = real_date.to_i(16).to_s

      price = string[32,8]
      real_price = price[6..7] + price[4..5] + price[2..3] + price[0..1]
      real_price = real_price.to_i(16).to_f / 100

      if Stock.find_by(code: args.stock, date: real_date) == nil
        stock = Stock.new(code: args.stock, date: real_date, price: real_price)
        stock.save
      end
    end
  end

  desc "erase"
  task :erase, [:code, :date] => :environment do |task, args|
    Stock.delete_by(code: args.code, date: args.date)
  end

  namespace :erase do
    desc "erase all"
    task :all => :environment do
      Stock.delete_all
    end
  end
  
  desc "add"
  task :add, [:code, :date, :price] => :environment do |task, args|
    stock = Stock.new(code: args.code, date: args.date, price: args.price)
    stock.save
  end
end