module Stave  
  class Stave
  
    def initialize(good_area, good_years)
      @good_area    = good_area
      @good_years   = good_years
    end

    def good_result
      StocksStaveLoha.delete_all
      StocksStaveYear.delete_all
      StocksBollsLoha.delete_all
      StocksBollsYear.delete_all
      puts "Stave'in... #{STAVE}"
      StocksCoefsStav.all.with_progress do |stock_stav|
        good_stock    = stock_stav.stock
        Progress.note = good_stock.upcase

        loha_engine  = _engin(SZSTK, LOHAS)
        year_engine  = _engin(SZSTK, YEARS)

        stave_lohas  = _stave(loha_engine, LOHAS, good_stock)
        stave_years  = _stave(year_engine, YEARS, good_stock)
        bolls_lohas  = _bolls(loha_engine, LOHAS, good_stock)
        bolls_years  = _bolls(year_engine, YEARS, good_stock)

        good_staves(StocksStaveLoha, stave_lohas, good_stock)
        good_staves(StocksStaveYear, stave_years, good_stock)
        good_staves(StocksBollsLoha, bolls_lohas, good_stock)
        good_staves(StocksBollsYear, bolls_years, good_stock)
      end
    end

    def good_staves(good_table, good_stave, good_stock)
      good_stave.each do |good_stave_|
        good_stock      = good_table.new(
          stock:        good_stock,
          price:        good_stave_[1],
          date:         good_stave_[0],
          years:        @good_years
        )
        good_stock.save
      end
    end

    def good_show(good_stock)
      loha_engine  = _engin(SZSTK, LOHAS)
      year_engine  = _engin(SZSTK, YEARS)
      
      stave_lohas  = _stave(loha_engine, LOHAS, good_stock)
      stave_years  = _stave(year_engine, YEARS, good_stock)
      bolls_lohas  = _bolls(loha_engine, LOHAS, good_stock)
      bolls_years  = _bolls(year_engine, YEARS, good_stock)
      
      return stave_lohas, stave_years, bolls_lohas, bolls_years
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
      stock_price   = _price(stocks, years, stock)
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
  
    def _bolls(stocks, years, stock)
      stock_price   = _price(stocks, years, stock)
      stave_boll    = stocks.good_aver(stock, STAVE        )
      stave_mup     = stocks.good_boll(stock, STAVE, true  )
      stave_mdn     = stocks.good_boll(stock, STAVE, false )
      stock_price   = _better(stock_price,  years )
      stave_boll    = _better(stave_boll,   years )
      stave_mup     = _better(stave_mup,    years )
      stave_mdn     = _better(stave_mdn,    years )
      bolls = [
        { name: "P", data: stock_price }, 
        { name: "B", data: stave_boll  },
        { name: "U", data: stave_mup   },
        { name: "D", data: stave_mdn   }
      ]  
      bolls
    end

  end
end
