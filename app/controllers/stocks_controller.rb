class StocksController < ApplicationController

  WEEK            = 5
  YEAR            = 250
  STAV            = 20  * WEEK
  LOHA            = 3   * YEAR + YEAR / 2
  SMOO            = 2   * WEEK

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
      years = years.to_i
      @boll, @lohas = single(stock, years)
    else
      @bol3, @lohas = single(stock, 875  )
      @bol1, @years = single(stock, 250  )
    end

    @stock        = stock
  end

  def single(stock, years)
    stocks        = Stave::Stock.new( "sz",   years         )

    start         = STAV - SMOO
    size          = years + 1

    stock_price   = stocks.good_aver( stock,  SMOO          )
    stock_price   = stock_price.slice(start,  size          )

    stave_boll    = stocks.good_aver( stock,  STAV          )
    stave_mup     = stocks.good_boll( stock,  STAV,  true   )
    stave_mdn     = stocks.good_boll( stock,  STAV,  false  )

    stave_trend   = stocks.good_trend(stock                 )
    stave_up1     = stocks.good_stave(stock,  true,   1     )
    stave_dn1     = stocks.good_stave(stock,  false,  1     )
    stave_top     = stocks.good_stave(stock,  true,   2     )
    stave_bot     = stocks.good_stave(stock,  false,  2     )

    boll = [
      { name: "Price",  data: stock_price }, 
      { name: "Boll",   data: stave_boll  },
      { name: "Up",     data: stave_mup   },
      { name: "Down",   data: stave_mdn   }
    ]

    stave = [
      { name: "Price",  data: stock_price }, 
      { name: "Trend",  data: stave_trend },
      { name: "Up",     data: stave_up1   },
      { name: "Down",   data: stave_dn1   },
      { name: "Top",    data: stave_top   },
      { name: "Bottom", data: stave_bot   }
    ]

    return boll, stave
  end

end
