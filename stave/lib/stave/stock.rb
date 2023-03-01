module Stave
  class Stock
    def initialize(good_area, good_days)
      @good_area = good_area
      @good_days = good_days
      @good_coefs = []
    end

    STAVE = 100

    def good_models
      good_stocks = _good_stocks
      puts "Modeling..."
      good_stocks.with_progress do |good_stock|
        Progress.note = good_stock
        good_model = _good_model(good_stock)
        if good_model.empty?
          next
        end
        @good_coefs.push good_model
      end
      @good_coefs.sort_by! {|good_coef| -good_coef[:coef]}
    end

    def good_import(good_table)
      good_table.delete_all
      puts "Importing..."
      @good_coefs.with_progress do |good_coef|
        good_stock = good_coef[:stock]
        good_last  = good_coef[:price]
        Progress.note = good_stock
        good_trend = good_trend(good_stock)
        good_trend = good_trend[-1][1]
        good_price = good_last > good_trend
        good_stock = good_table.new(
          stock:  good_stock, 
          coef:   good_coef[:coef], 
          inter:  good_coef[:inter], 
          price:  good_last,
          good:   good_price
        )
        good_stock.save
      end
    end

    def good_aver(good_stock, good_days)
      good_aver = _good_aver(good_stock, good_days)
      good_start = good_days - 1
      good_end = good_aver.size - 1
      good_aver = good_aver.slice!(good_start, good_end - good_start + 1)
      good_aver
    end

    def good_trend(good_stock)
      good_trend  = _good_trend(good_stock)
      good_trend = good_trend.pluck(:date, :price)
      good_trend
    end

    def good_stave(good_stock, good_stave, good_multi)
      good_data = good_trend(good_stock)
      good_sqrt = _good_sqrt(good_stock)
      if good_stave == true
        good_data.map! { |good_date, good_price| [good_date, good_price - good_sqrt * good_multi] }
      else
        good_data.map! { |good_date, good_price| [good_date, good_price + good_sqrt * good_multi] }
      end
    end

    def good_boll(good_stock, good_days, good_boll)
      good_aver = _good_aver(good_stock, good_days)
      good_sqrt = _good_boll(good_stock, good_days)
      good_start = good_aver.size - good_sqrt.size
      good_end = good_aver.size - 1
      for good_index in good_start..good_end
        if good_boll == true
          good_aver[good_index][1] += 2 * good_sqrt[good_index - good_start]
        else
          good_aver[good_index][1] -= 2 * good_sqrt[good_index - good_start]
        end
      end
      good_aver = good_aver.slice!(good_start, good_end - good_start + 1)
      good_aver
    end

    private

    def _good_move(good_price, good_days)
      good_move = good_price.each_cons(good_days).map { 
        |good_aver| good_aver.reduce(&:+).fdiv(good_days).round(2) 
      }
    end

    def _good_aver(good_stock, good_days)
      good_data = _good_data(good_stock)
      good_price = good_data.pluck(:price)
      good_aver = _good_move(good_price, good_days)
      good_start = good_price.size - good_aver.size
      good_end = good_price.size - 1
      for good_index in good_start..good_end
        good_data[good_index][:price] = good_aver[good_index - good_start]
      end
      good_data.pluck(:date, :price)
    end

    def _good_dist(good_stock, good_days)
      good_data = _good_days(good_stock, good_days).pluck(:date, :price)
      good_aver = _good_aver(good_stock, good_days)
      good_data.each_with_index do |good_data_, good_index|
        good_data[good_index][1] = good_data_[1] - good_aver[good_index][1]
        good_data[good_index][1] = good_data[good_index][1] ** 2
      end
      good_data
    end

    def _good_boll(good_stock, good_days)
      good_dist = _good_dist(good_stock, good_days)
      good_dist.map! { |good_date, good_price| good_price }
      good_sqrt = _good_move(good_dist, good_days)
      good_sqrt.each_with_index do |good_data, good_index|
        good_sqrt[good_index] = Math.sqrt(good_data)
      end
      good_sqrt
    end
    
    def _good_days(good_stock, good_days)
      good_data = _good_data(good_stock)
      good_start = STAVE - good_days
      good_end = good_data.size - 1
      good_data = good_data.slice!(good_start, good_end - good_start + 1)
      good_data
    end

    def _good_stave(good_stock)
      good_data = _good_data(good_stock)
      good_start = STAVE - 1
      good_end = good_data.size - 1
      good_data = good_data.slice!(good_start, good_end - good_start + 1)
      good_data
    end

    def _good_stock(good_file, good_index)
      good_binary = good_file.read(32)
      good_string = good_binary.unpack("H*")[0]
      good_date = good_string[0,8]
      good_date = good_date[6..7] + good_date[4..5] + good_date[2..3] + good_date[0..1]
      good_date = good_date.to_i(16).to_s
      good_price = good_string[32,8]
      good_price = good_price[6..7] + good_price[4..5] + good_price[2..3] + good_price[0..1]
      good_price = good_price.to_i(16).to_f / STAVE
      good_stock = {date: good_date.to_date, price: good_price, index: good_index}
      good_stock
    end

    def _good_data(good_stock) 
      good_file = _good_file(good_stock)
      if good_file.nil?
        return []
      end
      good_data = []
      good_index = 0
      good_file.pos = good_file.size - 1 * 32
      good_stock = _good_stock(good_file, good_index)
      if good_stock[:price] > STAVE
        return []
      end
      good_file.pos = good_file.size - @good_days * 32
      while good_file.eof == false
        good_stock = _good_stock(good_file, good_index)
        good_data.push good_stock
        good_index += 1
      end
      good_data
    end

    def _good_model(good_stock)
      good_data = _good_data(good_stock)
      if good_data.empty?
        return {}
      end
      if good_data[-1][:price] > STAVE
        return {}
      end
      good_index = good_data.pluck(:index)
      good_price = good_data.pluck(:price)
      good_model = Eps::LinearRegression.new(good_index, good_price, split: false)
      good_coef = good_model.coefficients[:x0]
      if good_coef < 1.0 / STAVE
        return {}
      end
      good_inter = good_model.coefficients[:_intercept]
      good_last  = good_data[-1][:price]
      good_model = { 
        stock:  good_stock, 
        coef:   good_coef, 
        inter:  good_inter, 
        price:  good_last,
      }
      good_model
    end

    def _good_trend(good_stock)
      good_stave = _good_stave(good_stock)
      good_model = _good_model(good_stock)
      good_stave.each_with_index do |good_data, good_index|
        good_stave[good_index][:price] = good_model[:coef] * good_index + good_model[:inter]
      end
      good_stave
    end

    def _good_sqrt(good_stock)
      good_stave = _good_stave(good_stock)
      good_trend = _good_trend(good_stock)
      good_stave.each_with_index do |good_data, good_index|
        good_stave[good_index][:price] = good_stave[good_index][:price] - good_trend[good_index][:price]
        good_stave[good_index][:price] = good_stave[good_index][:price] ** 2
      end
      good_price  = good_stave.pluck(:price)
      good_sum    = good_price.sum
      good_div    = good_sum / good_trend.size
      good_sqrt   = Math.sqrt(good_div)
      good_sqrt
    end

    def _good_stocks
      good_files = _good_files
      good_stocks = []
      good_files.each do |good_file|
        good_stock = good_file[0,8]
        good_stocks.push good_stock
      end
      good_stocks
    end

    def _good_files
      good_files = Dir.entries(_good_base)
      good_files.delete(".")
      good_files.delete("..")
      good_files.delete_if{ |good_file| _good_file(good_file[0,8]).nil? }
      good_files
    end

    def _good_file(good_stock)
      good_path = _good_path(good_stock)
      good_file = nil
      if File.size(good_path) > @good_days * 32
        good_file = File.open(good_path)
      end
      good_file
    end

    def _good_path(good_stock)
      good_path = _good_base + good_stock + ".day"
      good_path
    end

    def _good_base
      good_base = "vipdoc/" + @good_area + "/lday/"
      good_base
    end

  end
end
