desc "lohas"
task :lohas, [:area, :days] => :environment do |task, args|
  area = unless args.area.nil? then args.area else Stave::SZSTK end
  days = unless args.days.nil? then args.days else Stave::LOHAS end
  stock = Stave::Stock.new(area, days)
  stock.good_models()
  stock.good_staves(StocksCoefsLoha)
end

desc "years"
task :years, [:area, :days] => :environment do |task, args|
  area = unless args.area.nil? then args.area else Stave::SZSTK end
  days = unless args.days.nil? then args.days else Stave::YEARS end
  stock = Stave::Stock.new(area, days)
  stock.good_models()
  stock.good_staves(StocksCoefsYear)
end

desc "stave"
task :stave, [:area, :days] => :environment do |task, args|
  area = unless args.area.nil? then args.area else Stave::SZSTK end
  days = unless args.days.nil? then args.days else Stave::STAVE end
  stock = Stave::Stock.new(area, days)
  stave = Stave::Stave.new(area, days)
  stock.good_result()
  stave.good_result()
end

desc "stock"
task :stock, [:area, :days] => :environment do |task, args|
  area = unless args.area.nil? then args.area else Stave::SZSTK end
  days = unless args.days.nil? then args.days else Stave::STAVE end
  puts "#{Stock::VERSION}"
end