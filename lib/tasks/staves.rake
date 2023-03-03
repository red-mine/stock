desc "staves"
task :staves, [:area, :days] => :environment do |task, args|
  area = unless args.area.nil? then args.area else "sz" end
  days = unless args.days.nil? then args.days else 250 + 100 end
  stock = Stave::Stock.new(area, days)
  stock.good_models()
  stock.good_staves(StocksCoefsYear)
end

namespace :staves do
  desc "TODO"
  task fetch: :environment do
  end

  desc "TODO"
  task erase: :environment do
  end

  desc "TODO"
  task add: :environment do
  end

end
