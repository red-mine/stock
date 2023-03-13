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
      puts "Store'in... #{STAVE}"
      StocksCoefsStav.all.with_progress do |stock_stav|
        good_stock    = stock_stav.stock
        Progress.note = good_stock.upcase

        loha_engine  = _engin(SZSTK, LOHAS)
        year_engine  = _engin(SZSTK, YEARS)

        lohas_price, lohas_trend, lohas_up1, lohas_dn1, lohas_top, lohas_bot = _stave(loha_engine, LOHAS, good_stock)
        years_price, years_trend, years_up1, years_dn1, years_top, years_bot = _stave(year_engine, YEARS, good_stock)

        lohas_price, lohas_bolls, lohas_mup, lohas_mdn = _bolls(loha_engine, LOHAS, good_stock)
        years_price, years_bolls, years_mup, years_mdn = _bolls(year_engine, YEARS, good_stock)

        good_staves(StocksStaveLoha, lohas_price, good_stock, "price" )
        good_staves(StocksStaveLoha, lohas_trend, good_stock, "trend" )
        good_staves(StocksStaveLoha, lohas_up1,   good_stock, "up1"   )
        good_staves(StocksStaveLoha, lohas_dn1,   good_stock, "dn1"   )
        good_staves(StocksStaveLoha, lohas_top,   good_stock, "top"   )
        good_staves(StocksStaveLoha, lohas_bot,   good_stock, "bot"   )

        good_staves(StocksStaveYear, years_price, good_stock, "price" )
        good_staves(StocksStaveYear, years_trend, good_stock, "trend" )
        good_staves(StocksStaveYear, years_up1,   good_stock, "up1"   )
        good_staves(StocksStaveYear, years_dn1,   good_stock, "dn1"   )
        good_staves(StocksStaveYear, years_top,   good_stock, "top"   )
        good_staves(StocksStaveYear, years_bot,   good_stock, "bot"   )

        good_staves(StocksBollsLoha, lohas_price, good_stock, "price" )
        good_staves(StocksBollsLoha, lohas_bolls, good_stock, "bolls" )
        good_staves(StocksBollsLoha, lohas_mup,   good_stock, "mup"   )
        good_staves(StocksBollsLoha, lohas_mdn,   good_stock, "mdn"   )

        good_staves(StocksBollsYear, years_price, good_stock, "price" )
        good_staves(StocksBollsYear, years_bolls, good_stock, "bolls" )
        good_staves(StocksBollsYear, years_mup,   good_stock, "mup"   )
        good_staves(StocksBollsYear, years_mdn,   good_stock, "mdn"   )
      end
    end

    def good_staves(good_table, good_stave, good_stock, good_years)
      good_stave.each do |good_stave_|
        good_result   = good_table.new(
          stock:        good_stock,
          price:        good_stave_[1].round(2),
          date:         good_stave_[0],
          years:        good_years
        )
        good_result.save
      end
    end

    def good_show(good_stock)
      stave_lohas, stave_years = _stave_show(good_stock)
      bolls_lohas, bolls_years = _bolls_show(good_stock)

      return stave_lohas, stave_years, bolls_lohas, bolls_years
    end

    def good_index(good_stock)
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
  
    def _stave_show(stock)
      lohas_price   = _stave_filter(StocksStaveLoha,  "price" )
      lohas_trend   = _stave_filter(StocksStaveLoha,  "trend" )
      lohas_up1     = _stave_filter(StocksStaveLoha,  "up1"   )
      lohas_dn1     = _stave_filter(StocksStaveLoha,  "dn1"   )
      lohas_top     = _stave_filter(StocksStaveLoha,  "top"   )
      lohas_bot     = _stave_filter(StocksStaveLoha,  "bot"   )

      lohas_show = [
        { name: "P", data: lohas_price }, 
        { name: "T", data: lohas_trend },
        { name: "U", data: lohas_up1   },
        { name: "D", data: lohas_dn1   },
        { name: "T", data: lohas_top   },
        { name: "B", data: lohas_bot   }
      ]

      years_price   = _stave_filter(StocksStaveYear,  "price" )
      years_trend   = _stave_filter(StocksStaveYear,  "trend" )
      years_up1     = _stave_filter(StocksStaveYear,  "up1"   )
      years_dn1     = _stave_filter(StocksStaveYear,  "dn1"   )
      years_top     = _stave_filter(StocksStaveYear,  "top"   )
      years_bot     = _stave_filter(StocksStaveYear,  "bot"   )

      years_show = [
        { name: "P", data: years_price }, 
        { name: "T", data: years_trend },
        { name: "U", data: years_up1   },
        { name: "D", data: years_dn1   },
        { name: "T", data: years_top   },
        { name: "B", data: years_bot   }
      ]

      return lohas_show, years_show
    end

    def _stave_filter(good_table, good_filter)
      good_arel = good_table.arel_table
      stave_filter = good_table
        .where(good_arel[:years].eq(good_filter))
        .pluck(good_arel[:date], good_arel[:price])
      stave_filter
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

      return stock_price, stave_trend, stave_up1, stave_dn1, stave_top, stave_bot
    end
  
    def _bolls_show(stock)
      lohas_price   = _stave_filter(StocksBollsLoha,  "price" )
      lohas_bolls   = _stave_filter(StocksBollsLoha,  "bolls" )
      lohas_mup     = _stave_filter(StocksBollsLoha,  "mup"   )
      lohas_mdn     = _stave_filter(StocksBollsLoha,  "mdn"   )

      lohas_show = [
        { name: "P", data: lohas_price }, 
        { name: "B", data: lohas_bolls },
        { name: "U", data: lohas_mup   },
        { name: "D", data: lohas_mdn   }
      ]

      years_price   = _stave_filter(StocksBollsYear,  "price" )
      years_bolls   = _stave_filter(StocksBollsYear,  "bolls" )
      years_mup     = _stave_filter(StocksBollsYear,  "mup"   )
      years_mdn     = _stave_filter(StocksBollsYear,  "mdn"   )

      years_show = [
        { name: "P", data: years_price }, 
        { name: "B", data: years_bolls },
        { name: "U", data: years_mup   },
        { name: "D", data: years_mdn   }
      ]

      return lohas_show, years_show
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

      return stock_price, stave_boll, stave_mup, stave_mdn
    end

  end
end
