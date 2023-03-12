module Stave  
  class Stave
  
    def initialize(good_area, good_years, good_stock)
      @good_area    = good_area
      @good_years   = good_years
      @good_stock   = good_stock
    end

    def self.good_stave
      StocksStav.delete_all
      puts "Stave'in... #{STAVE}"
      StocksStav.all.with_progress do |stock_stav|
        Progress.note = stock_stav.stock.upcase
        good_stave    = StocksStav.new(
          stock:      stock_stav.stock,
          price:      stock_stav.price,
          date:       stock_stav.date,
          years:      stock_stav.years
        )
        good_stave.save
      end
    end

    def good_staves(good_table, good_stave, good_stock)
      good_table.delete_all
      puts "Stave'in... #{good_stock}"
      good_stave.with_progress do |good_stave_|
        Progress.note   = good_stave_[0]
        good_stock      = good_table.new(
          stock:        good_stock,
          price:        good_stave_[1],
          date:         good_stave_[0],
          years:        good_years
        )
        good_stock.save
      end
    end

    def good_stave(good_stock, good_years)
      good_lohas, good_years, good_stave, good_bolls = good_show(good_stock, good_years)
      good_staves(StocksLoha, good_lohas, good_stock, good_years)
      good_staves(StocksYear, good_years, good_stock, good_years)
      good_staves(StocksStav, good_stave, good_stock, good_years)
      good_staves(StocksBoll, good_bolls, good_stock, good_years)
    end

    def good_index(good_stock, good_commit)
      staves_arel   = StocksCoefsStav.arel_table
      stocks_stavs  = if good_stock.nil?
        StocksCoefsStav.where(staves_arel[:lohas].not_eq(""))
      elsif good_stock.empty?
        StocksCoefsStav.all
      else
        StocksCoefsStav.where(staves_arel[:stock].matches_any(["%" + good_stock + "%"]))
      end
      stavs_date    = stocks_stavs.pluck(staves_arel[:date])[-1]
      return stocks_stavs, stavs_date
    end
  
    def good_show(good_stock, good_years)
      if good_years.nil?
        good_lohas  = _engin(SZSTK, LOHAS)
        good_years  = _engin(SZSTK, YEARS)
        good_lohas  = _stave(good_lohas, LOHAS, good_stock)
        good_years  = _stave(good_years, YEARS, good_stock)
        good_bolls  = nil
        good_stave  = nil
      else
        good_years  = good_years.to_i
        good_engin  = _engin(SZSTK, good_years)
        good_stave  = _stave(good_engin, good_years, good_stock)
        good_bolls  = _bolls(good_engin, good_years, good_stock)
        good_years  = nil
        good_lohas  = nil
      end
      return good_lohas, good_years, good_stave, good_bolls
    end

    private
  
    def _engin(area, years)
      engine  = Stock.new(area, years)
      engine
    end
  
    def _week(stave)
      week    = []
      stave.each do |_stave|
        date  = _stave[0]
        wday  = date.wday
        if wday == 1
          week.push _stave
        end
      end
      week
    end
  
    def _month(stave)
      month   = []
      stave.each do |_stave|
        date  = _stave[0]
        mday  = date.mday
        if mday == 1
          month.push _stave
        end
      end
      month
    end
  
    def _quarter(stave)
      quarter = []
      stave.each do |_stave|
        date  = _stave[0]
        if date == date.beginning_of_quarter
          quarter.push _stave
        end
      end
      quarter
    end
  
    def _smooth(stave)
      smooth  = []
      _date   = nil
      _price  = 0
      stave.each do |_stave|
        date  = _stave[0]
        price = _stave[1]
        if !_date.nil?
          days  = (date   - _date).numerator
          dist  = (price  - _price) / days
          if days != 1
            days  = days - 1
            while days != 0
              day   = [date - days, price - dist * days]
              smooth.push day
              days  = days - 1
            end
          end
        end
        _date   = date
        _price  = price
        smooth.push _stave
      end
      smooth
    end
  
    def _better(stave, years)
      smooth = _smooth(stave)
      better = if years == LOHAS
        _quarter(smooth)
      else
        _month(smooth)
      end
      better
    end
  
    def _price(stocks, years, stock)
      start         = STAVE - SMUTH
      length        = years + 1
      price         = stocks.good_aver(stock, SMUTH).slice(start, length)
      price
    end
  
    def _stave(stocks, years, stock)
      stock_price   = _price(stocks, years)
      stave_trend   = stocks.good_trend(stock             )
      stave_up1     = stocks.good_stave(stock,  true,   1 )
      stave_dn1     = stocks.good_stave(stock,  false,  1 )
      stave_top     = stocks.good_stave(stock,  true,   2 )
      stave_bot     = stocks.good_stave(stock,  false,  2 )
      stock_price   = _better(stock_price,  years )
      stave_trend   = _better(stave_trend,  years )
      stave_up1     = _better(stave_up1,    years )
      stave_dn1     = _better(stave_dn1,    years )
      stave_top     = _better(stave_top,    years )
      stave_bot     = _better(stave_bot,    years )
      stave = [
        { name: "P", data: stock_price }, 
        { name: "T", data: stave_trend },
        { name: "U", data: stave_up1   },
        { name: "D", data: stave_dn1   },
        { name: "T", data: stave_top   },
        { name: "B", data: stave_bot   }
      ]
      stave
    end
  
    def _boll(stocks, years, stock)
      stock_price   = _price(stocks, years)
      stave_boll    = stocks.good_aver(stock, STAVE        )
      stave_mup     = stocks.good_boll(stock, STAVE, true  )
      stave_mdn     = stocks.good_boll(stock, STAVE, false )
      stock_price   = _better(stock_price,  years )
      stave_boll    = _better(stave_boll,   years )
      stave_mup     = _better(stave_mup,    years )
      stave_mdn     = _better(stave_mdn,    years )
      boll = [
        { name: "P", data: stock_price }, 
        { name: "B", data: stave_boll  },
        { name: "U", data: stave_mup   },
        { name: "D", data: stave_mdn   }
      ]  
      boll
    end

  end
end
