module Stave
  class Engine < ::Rails::Engine
    isolate_namespace Stave

    SMOOTH  = 2 * Stave::WEEKS
  
    def generate(stock, years)
      @stock        = stock

      stave, lohas  = if !years.nil?
        years   = years.to_i

        stocks  = _engine(Stave::STOCK, years)

        stave   = _stave(stocks, years)
        boll    = _boll(stocks, years)

        stave, boll
      else
        stocks  = _engine(Stave::STOCK,  Stave::LOHAS)
        stave   = _stave(stocks, Stave::LOHAS)

        stocks  = _engine(Stave::STOCK,  Stave::YEARS)
        years   = _stave(stocks, Stave::YEARS)

        stave, years
      end

      stave, lohas
    end
  
  private
  
    def _engine(area, years)
      engine  = Stave::Stock.new(area, years)
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
      better = if years == Stave::LOHAS
        _quarter(smooth)
      else
        _month(smooth)
      end
      better
    end
  
    def _price(stocks, years)
      stock         = @stock
      start         = Stave::STAVE - SMOOTH
      length        = years + 1
      price         = stocks.good_aver(stock,  SMOOTH).slice(start, length)
      price
    end
  
    def _stave(stocks, years)
      stock         = @stock
  
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
  
    def _boll(stocks, years)
      stock         = @stock
  
      stock_price   = _price(stocks, years)
      
      stave_boll    = stocks.good_aver(stock, Stave::STAVE        )
      stave_mup     = stocks.good_boll(stock, Stave::STAVE, true  )
      stave_mdn     = stocks.good_boll(stock, Stave::STAVE, false )
  
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
