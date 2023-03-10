module Stave
  class Stock

    def initialize(good_area, good_years)
      @good_area    = good_area
      @good_years   = good_years
      @good_days    = good_years + STAVE
      @good_models  = []
    end

    def good_result
      StocksCoefsStav.delete_all
      puts "Stave'in... #{STAVE}"
      StocksCoefsLoha.all.with_progress do |stock_loha|
        Progress.note   = stock_loha.stock.upcase
        StocksCoefsYear.all.each do |stock_year|
          if stock_loha.stock == stock_year.stock
            good_stock  = StocksCoefsStav.new(
              stock:      stock_loha.stock,
              loha:       stock_loha.coef,
              year:       stock_year.coef,
              price:      stock_loha.price,
              good:       stock_loha.good,
              lohas:      stock_loha.stave,
              years:      stock_year.stave,
              boll3:      stock_loha.boll,
              stav3:      stock_loha.stav,
              boll1:      stock_year.boll,
              stav1:      stock_year.stav,
              date:       stock_loha.date,
            )
            good_stock.save
          end
        end
      end
    end

    def good_models
      good_stocks   = _good_stocks
      puts "Stock'in... #{@good_years}"
      good_stocks.with_progress do |good_stock|
        Progress.note   = good_stock.upcase
        good_model      = _good_model(good_stock)
        next if           good_model.empty?
        @good_models.push good_model
      end
      @good_models.sort_by! {
        |good_model|      -good_model[:coef]
      }
    end

    def good_staves(good_table)
      good_table.delete_all
      puts "Stave'in... #{@good_years}"
      @good_models.with_progress do |good_model|
        Progress.note   = good_model[:stock].upcase
        good_price, good_stave, good_boll, good_stav = _good_price(good_model)
        good_stock      = good_table.new(
          stock:        good_model[:stock],
          coef:         good_model[:coef],
          inter:        good_model[:inter],
          price:        good_model[:price],
          good:         good_price,
          stave:        good_stave,
          boll:         good_boll,
          stav:         good_stav,
          date:         good_model[:date],
          years:        @good_years
        )
        good_stock.save
      end
    end

    def good_aver(good_stock, good_days)
      good_aver   = _good_aver(good_stock, good_days)
      good_start  = good_days - 1
      good_end    = good_aver.size - 1
      good_aver   = good_aver.slice(good_start, good_end - good_start + 1)
      good_aver
    end

    def good_trend(good_stock)
      good_trend  = _good_trend(good_stock)
      good_trend  = good_trend.pluck(:date, :price)
      good_trend
    end

    def good_stave(good_stock, good_stave, good_multi)
      good_data       = good_trend(good_stock)
      good_sqrt       = _good_sqrt(good_stock)
      if good_stave
        good_data.map! { |good_date, good_price| 
          good_price  = good_price + good_sqrt * good_multi
          good_result = [good_date, good_price.round(2)] 
          good_result
        }
      else
        good_data.map! { |good_date, good_price|
          good_price  = good_price - good_sqrt * good_multi
          good_result = [good_date, good_price.round(2)] 
          good_result
        }
      end
      good_data
    end

    def good_boll(good_stock, good_days, good_boll)
      good_aver     = _good_aver(good_stock, good_days)
      good_sqrt     = _good_boll(good_stock, good_days)
      good_start    = good_aver.size - good_sqrt.size
      good_end      = good_aver.size - 1
      for good_index in good_start..good_end
        good_result = good_aver[good_index][1]
        good_double = good_sqrt[good_index - good_start] * 2
        good_result = if good_boll
          good_result + good_double
        else
          good_result - good_double
        end
        good_aver[good_index][1] = good_result.round(2)
      end
      good_boll     = good_aver.slice(good_start, good_end - good_start + 1)
      good_boll
    end

    private

    def _good_price(good_model)
      good_stock      = good_model[:stock]
      good_last       = good_model[:price]
      good_date       = good_model[:date]
      good_boll       = good_aver(good_stock, STAVE)[-1][1]
      good_mup        = good_boll(good_stock, STAVE, true)[-1][1]
      good_mdn        = good_boll(good_stock, STAVE, false)[-1][1]
      good_trend      = good_trend(good_stock)[-1][1]
      good_up1        = good_stave(good_stock, true,  1)[-1][1]
      good_dn1        = good_stave(good_stock, false, 1)[-1][1]
      good_up2        = good_stave(good_stock, true,  2)[-1][1]
      good_dn2        = good_stave(good_stock, false, 2)[-1][1]
      # price
      good_price      = good_last > good_trend && good_last > good_boll
      # trend
      good_up1_trend  = good_last < good_up1 && good_last > good_trend
      good_up1_up2    = good_last > good_up1 && good_last < good_up2
      good_up2_top    = good_last > good_up2
      good_dn1_trend  = good_last > good_dn1 && good_last < good_trend
      good_dn1_dn2    = good_last < good_dn1 && good_last > good_dn2
      good_dn2_bot    = good_last < good_dn2
      # boll
      good_mup_boll   = good_last < good_mup && good_last > good_boll
      good_mup_top    = good_last > good_mup
      good_mdn_boll   = good_last > good_mdn && good_last < good_boll
      good_mdn_bot    = good_last < good_mdn
      # stave
      good_stave      = "SAF-1" if good_dn1_dn2   && good_mdn_boll  # 1. SAFE - BUY !
      good_stave      = "SOX-2" if good_up1_up2   && good_mup_top   # 2. SOAR - KEEP !!!
      good_stave      = "SEL-3" if good_up1_up2   && good_mup_boll  # 3. SELL - up2 -> up1
      good_stave      = "BUY-4" if good_dn1_dn2   && good_mup_boll  # 4. BUY  - boll up ?
      good_stave      = "BUY-5" if good_up1_trend && good_mup_boll  # 5. BUY  - more - positive ?
      good_stave      = "SEL-6" if good_up1_up2   && good_mup_boll  # 6. SELL - some
      good_stave      = "SEL-7" if good_up1_up2   && good_mup_boll  # 7. SELL
      good_stave      = "WAT-8" if good_dn1_dn2   && good_mup_boll  # 8. WAIT - boll dn ?
      good_stave      = "WAT-9" if good_dn2_bot   && good_mdn_bot   # 9. WAIT - can not buy !
      good_stave      = "CHP-0" if good_dn2_bot   && good_mdn_bot   # 0. CHIP - BUY !
      # boll
      good_boll       = +1 if good_mup_boll
      good_boll       = +2 if good_mup_top
      good_boll       = -1 if good_mdn_boll
      good_boll       = -2 if good_mdn_bot
      # stave
      good_stav       = +1 if good_up1_trend
      good_stav       = +2 if good_up1_up2
      good_stav       = +3 if good_up2_top
      good_stav       = -1 if good_dn1_trend
      good_stav       = -2 if good_dn1_dn2
      good_stav       = -3 if good_dn2_bot
      return          good_price, good_stave, good_boll, good_stav
    end

    def _good_move(good_price, good_days)
      good_move   = good_price.each_cons(good_days).map { 
        |good_aver| good_aver.reduce(&:+).fdiv(good_days).round(2) 
      }
      good_move
    end

    def _good_aver(good_stock, good_days)
      good_data   = _good_data(good_stock)
      good_price  = good_data.pluck(:price)
      good_aver   = _good_move(good_price, good_days)
      good_start  = good_price.size - good_aver.size
      good_end    = good_price.size - 1
      for good_index in good_start..good_end
        good_data[good_index][:price] = good_aver[good_index - good_start]
      end
      good_data.pluck(:date, :price)
    end

    def _good_dist(good_stock, good_days)
      good_data   = _good_days(good_stock, good_days).pluck(:date, :price)
      good_aver   = _good_aver(good_stock, good_days)
      good_data.each_with_index do |good_data_, good_index|
        _good_data = good_data_[1] - good_aver[good_index][1]
        good_data[good_index][1] = _good_data ** 2
      end
      good_data
    end

    def _good_boll(good_stock, good_days)
      good_dist   = _good_dist(good_stock, good_days)
      good_dist.map! { |good_date, good_price| good_price }
      good_sqrt   = _good_move(good_dist, good_days)
      good_sqrt.each_with_index do |good_data, good_index|
        good_sqrt[good_index] = Math.sqrt(good_data).round(2)
      end
      good_sqrt
    end
    
    def _good_days(good_stock, good_days)
      good_data   = _good_data(good_stock)
      good_start  = STAVE - good_days
      good_end    = good_data.size - 1
      good_data   = good_data.slice(good_start, good_end - good_start + 1)
      good_data
    end

    def _good_stave(good_stock)
      good_data   = _good_data(good_stock)
      good_start  = STAVE - 1
      good_end    = good_data.size - 1
      good_data   = good_data.slice(good_start, good_end - good_start + 1)
      good_data
    end

    def _good_stock(good_file, good_index)
      good_binary = good_file.read(32)
      good_string = good_binary.unpack("H*")[0]
      good_date   = good_string[0,8]
      good_date   = good_date[6..7]   + good_date[4..5]   + good_date[2..3]   + good_date[0..1]
      good_date   = good_date.to_i(16).to_s
      good_price  = good_string[32,8]
      good_price  = good_price[6..7]  + good_price[4..5]  + good_price[2..3]  + good_price[0..1]
      good_price  = good_price.to_i(16).to_f / STAVE
      good_stock  = {
        date:       good_date.to_date,
        price:      good_price, 
        index:      good_index
      }
      good_stock
    end

    def _good_data(good_stock) 
      good_file     = _good_file(good_stock)
      return [] if good_file.nil?
      good_file.pos = good_file.size - 1 * 32
      good_stock    = _good_stock(good_file, -1)
      return [] if good_stock[:price] > STAVE
      good_index    = 0
      prev_stock    = {}
      good_data     = []
      good_file.pos = good_file.size - @good_days * 32
      while !good_file.eof?
        good_stock  = _good_stock(good_file, good_index)
        good_data.push good_stock
        good_index  += 1
      end
      good_data
    end

    def _good_model(good_stock)
      good_data   = _good_data(good_stock)
      return {} if  good_data.empty?
      return {} if  good_data[-1][:price] > STAVE
      good_index  = good_data.pluck(:index)
      good_price  = good_data.pluck(:price)
      good_date   = good_data.pluck(:date)[-1]
      good_model  = Eps::LinearRegression.new(good_index, good_price, split: false)
      good_coef   = good_model.coefficients[:x0]
      return {} if  good_coef < 1.0 / STAVE
      good_inter  = good_model.coefficients[:_intercept]
      good_last   = good_data[-1][:price]
      good_model  = { 
        stock:      good_stock, 
        coef:       good_coef, 
        inter:      good_inter, 
        price:      good_last,
        date:       good_date
      }
      good_model
    end

    def _good_trend(good_stock)
      good_stave  = _good_stave(good_stock)
      good_model  = _good_model(good_stock)
      good_stave.each_with_index do |good_data, good_index|
        good_price = good_stave[good_index][:price]
        good_price = good_model[:coef] * good_index + good_model[:inter]
        good_stave[good_index][:price] = good_price.round(2)
      end
      good_stave
    end

    def _good_sqrt(good_stock)
      good_stave  = _good_stave(good_stock)
      good_trend  = _good_trend(good_stock)
      good_stave.each_with_index do |good_data, good_index|
        good_price = good_stave[good_index][:price] - good_trend[good_index][:price]
        good_stave[good_index][:price] = good_price ** 2
      end
      good_price  = good_stave.pluck(:price)
      good_sum    = good_price.sum
      good_div    = good_sum / good_trend.size
      good_sqrt   = Math.sqrt(good_div)
      good_sqrt
    end

    def _good_stocks
      good_lohas  = StocksCoefsLoha.all
      good_stocks = []
      if good_lohas.empty?
        good_files  = _good_files
        good_files.each do |good_file|
          good_stock = good_file[0,8]
          good_stocks.push good_stock
        end
      else
        good_lohas.each do |good_loha|
          good_stock = good_loha.stock
          good_stocks.push good_stock
        end
      end
      good_stocks
    end

    def _good_files
      good_files  = Dir.entries(_good_base)
      good_files.delete(".")
      good_files.delete("..")
      good_files.delete_if{ |good_file| _good_file(good_file[0,8]).nil? }
      good_files
    end

    def _good_file(good_stock)
      good_path   = _good_path(good_stock)
      good_file   = nil
      if File.size(good_path) > @good_days * 32
        good_file = File.open(good_path)
      end
      good_file

    end

    def _good_path(good_stock)
      good_path   = _good_base + good_stock + ".day"
      good_path
    end

    def _good_base
      good_base   = "vipdoc/" + @good_area + "/lday/"
      good_base
    end

  end
end
