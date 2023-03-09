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
    stock         = params[:stock]
    years         = params[:years]

    if stock.nil?
      stock       = query.lowcase
    end

    if !years.nil?
      years       = years.to_i
      @boll, @stave = _single(stock, years)
    else
      @bol3, @stave = _single(stock, 875  )
      @bol1, @years = _single(stock, 250  )
    end

    @stock        = stock
  end

private

  def _smooth(good_smooth)
    Rails.logger.info "good_smooth = #{good_smooth}"
    good_smooth
  end

  def _single(stock, years)
    stocks        = Stave::Stock.new( "sz",   years         )

    start         = Stave::STAVE - SMOOTH
    length        = years + 1

    stock_price   = stocks.good_aver( stock,  SMOOTH).slice(start, length)

    stave_boll    = stocks.good_aver( stock,  Stave::STAVE         )
    stave_mup     = stocks.good_boll( stock,  Stave::STAVE,  true  )
    stave_mdn     = stocks.good_boll( stock,  Stave::STAVE,  false )

    stave_trend   = stocks.good_trend(stock                 )
    stave_up1     = stocks.good_stave(stock,  true,   1     )
    stave_dn1     = stocks.good_stave(stock,  false,  1     )
    stave_top     = stocks.good_stave(stock,  true,   2     )
    stave_bot     = stocks.good_stave(stock,  false,  2     )

    boll = [
      { name: "Price",  data: _smooth(stock_price) }, 
      { name: "Boll",   data: _smooth(stave_boll)  },
      { name: "Up",     data: _smooth(stave_mup)   },
      { name: "Down",   data: _smooth(stave_mdn)   }
    ]

    stave = [
      { name: "Price",  data: _smooth(stock_price) }, 
      { name: "Trend",  data: _smooth(stave_trend) },
      { name: "Up",     data: _smooth(stave_up1)   },
      { name: "Down",   data: _smooth(stave_dn1)   },
      { name: "Top",    data: _smooth(stave_top)   },
      { name: "Bottom", data: _smooth(stave_bot)   }
    ]

    return boll, stave
  end

end
