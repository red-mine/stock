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
task :stave => :environment do
  Stave::Stock.good_stave()
  Stave::Stave.good_stave()
end