class StocksController < ApplicationController

  SMOOTH = 2 * Stave::WEEKS

  def index
    stock         = params[:stock]
    commit        = params[:commit]

    stocks_stavs  = StocksCoefsStav.arel_table

    @stocks_stavs = if stock.nil?
      StocksCoefsStav.where(stocks_stavs[:lohas].not_eq(""))
    elsif stock.empty?
      StocksCoefsStav.all
    else
      StocksCoefsStav.where(stocks_stavs[:stock].matches_any(["%" + stock.downcase + "%"]))
    end

    @stavs_date   = @stocks_stavs.pluck(stocks_stavs[:date])[-1]
  end

  def show
    stock     = params[:stock]
    years     = params[:years]

    if stock.nil?
      stock   = query.lowcase
    end

    if !years.nil?
      years   = years.to_i
      @stocks = Stave::Stock.new("sz", years)
      @stave  = _stave(stock, years)
      @boll   =  _boll(stock, years)
    else
      @stocks = Stave::Stock.new("sz", 875)
      @stave  = _stave(stock, 875  )
      @stocks = Stave::Stock.new("sz", 250)
      @years  = _stave(stock, 250  )
    end

    @stock    = stock
  end

private

  def _smooth(good_stave)
    good_smooth = []
    prev_date   = nil
    prev_price  = 0
    good_stave.each do |_good_stave|
      good_date   = _good_stave[0]
      good_price  = _good_stave[1]
      if !prev_date.nil?
        good_days   = (good_date - prev_date).numerator
        dist_price  = (good_price - prev_price) / good_days
        if good_days  != 1
          good_days   = good_days - 1
          while good_days != 0
            good_day  = [good_date - good_days, good_price - dist_price * good_days]
            good_smooth.push good_day
            good_days = good_days - 1
          end
        end
      end
      prev_date   = good_date
      prev_price  = good_price
      good_smooth.push _good_stave
    end
    good_smooth
  end

  def _price(stock, years)
    start         = Stave::STAVE - SMOOTH
    length        = years + 1

    stock_price   = @stocks.good_aver( stock,  SMOOTH).slice(start, length)

    stock_price
  end

  def _stave(stock, years)
    stocks        = @stocks

    stock_price   = _price(stock, years)

    stave_trend   = stocks.good_trend(stock                 )
    stave_up1     = stocks.good_stave(stock,  true,   1     )
    stave_dn1     = stocks.good_stave(stock,  false,  1     )
    stave_top     = stocks.good_stave(stock,  true,   2     )
    stave_bot     = stocks.good_stave(stock,  false,  2     )

    stock_price   = _smooth(stock_price)
    stave_trend   = _smooth(stave_trend)
    stave_up1     = _smooth(stave_up1)
    stave_dn1     = _smooth(stave_dn1)
    stave_top     = _smooth(stave_top)
    stave_bot     = _smooth(stave_bot)

    stave = [
      { name: "Price",  data: stock_price }, 
      { name: "Trend",  data: stave_trend },
      { name: "Up",     data: stave_up1   },
      { name: "Down",   data: stave_dn1   },
      { name: "Top",    data: stave_top   },
      { name: "Bottom", data: stave_bot   }
    ]

    return stave
  end

  def _boll(stock, years)
    stocks        = @stocks

    stock_price   = _price(stock, years)

    stave_boll    = stocks.good_aver( stock,  Stave::STAVE         )
    stave_mup     = stocks.good_boll( stock,  Stave::STAVE,  true  )
    stave_mdn     = stocks.good_boll( stock,  Stave::STAVE,  false )

    stock_price   = _smooth(stock_price)
    stave_boll    = _smooth(stave_boll)
    stave_mup     = _smooth(stave_mup)
    stave_mdn     = _smooth(stave_mdn)

    boll = [
      { name: "Price",  data: stock_price }, 
      { name: "Boll",   data: stave_boll  },
      { name: "Up",     data: stave_mup   },
      { name: "Down",   data: stave_mdn   }
    ]

    return boll
  end

end
