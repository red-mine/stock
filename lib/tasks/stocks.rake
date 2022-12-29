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
    Stave::Stock.import(args.stock, Stock)
  end

  namespace :import do
    desc "import all"
    task :all => :environment do
      basedir = "C:\\new_tdx\\vipdoc\\sz\\lday\\"
      files = Dir.entries(basedir)
      files.each do |file|
        if file != "." && file != ".."
          stock = file[0,8]
          p "Importing #{stock}"
          Stave::Stock.import(stock, Stock)
        end
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
    desc "erase id"
    task :id, [:id] => :environment do |task, args|
      Stock.delete_by(id: args.id)
    end
  end
  
  desc "model"
  task :model, [:stock] => :environment do |task, args|
    data = []
    stock = Stock.where(code: args.stock)
    stock.each_with_index do |stock, index|
      date = stock.date.to_s
      real_date = date[0,4] + date[5,2] + date[8,2]
      stock = {index: index, price: stock.price}
      data.push stock
    end
    # puts data
    model = Eps::LinearRegression.new(data, target: :price, split: false)
    puts model.summary
    puts model.coefficients
  end

  namespace :model do
    desc "pridict"
    task :pridict => :environment do
    end

    desc "store"
    task :store => :environment do
    end

    desc "all"
    task :all => :environment do
      basedir = "C:\\new_tdx\\vipdoc\\sz\\lday\\"
      files = Dir.entries(basedir)
      # puts files
      puts "This is a test".to_squawk

      Stave::Stock.model_all
    end

    desc "stock"
    task :stock, [:stock] => :environment do |task, args|
      file_path = "C:\\new_tdx\\vipdoc\\sz\\lday\\" + args.stock + ".day"
      file = File.open(file_path)
      data = []
      index = 0
      while file.eof == false
        file_data = file.read(32)
        string = file_data.unpack("H*")[0]
  
        date = string[0,8]
        real_date = date[6..7] + date[4..5] + date[2..3] + date[0..1]
        real_date = real_date.to_i(16).to_s
  
        price = string[32,8]
        real_price = price[6..7] + price[4..5] + price[2..3] + price[0..1]
        real_price = real_price.to_i(16).to_f / 100

        real_date = real_date[0,4] + real_date[5,2] + real_date[8,2]
        stock = {index: index, price: real_price}
        data.push stock

        index = index + 1
      end
      # puts data
      model = Eps::LinearRegression.new(data, target: :price, split: false)
      puts model.summary
      puts model.coefficients
    end
  end

  desc "add"
  task :add, [:code, :date, :price] => :environment do |task, args|
    if args.code == nil || args.date == nil || args.price == nil
      p "code or date or price can not be empty"
      exit
    end
    p "add"
    stock = Stock.new(code: args.code, date: args.date, price: args.price)
    stock.save
  end
end