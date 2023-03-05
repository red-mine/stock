class StocksController < ApplicationController

  WEEK            = 5
  YEAR            = 250
  STAV            = 20  * WEEK
  LOHA            = 3   * YEAR + YEAR / 2
  SMOO            = 2   * WEEK

  def index
    years         = params[:years].to_i

    @stocks_lohas = StocksCoefsLoha.all
    @stocks_years = StocksCoefsYear.all

    stocks_lohas  = StocksCoefsLoha.arel_table
    stocks_years  = StocksCoefsYear.arel_table

    @lohas_date   = @stocks_lohas.pluck(stocks_lohas[:date])[-1]
    @years_date   = @stocks_years.pluck(stocks_years[:date])[-1]
  end

  def show
    stock         = params[:stock]
    years         = params[:years].to_i
    
    stocks        = Stave::Stock.new( "sz",   years + STAVE )

    start         = STAVE - SMOOTH
    size          = years + 1

    stock_price   = stocks.good_aver( stock,  SMOOTH        )
    stock_price   = stock_price.slice(start,  size          )

    stave_boll    = stocks.good_aver( stock,  STAVE         )
    stave_mup     = stocks.good_boll( stock,  STAVE,  true  )
    stave_mdn     = stocks.good_boll( stock,  STAVE,  false )

    stave_trend   = stocks.good_trend(stock                 )
    stave_up1     = stocks.good_stave(stock,  true,   1     )
    stave_dn1     = stocks.good_stave(stock,  false,  1     )
    stave_top     = stocks.good_stave(stock,  true,   2     )
    stave_bot     = stocks.good_stave(stock,  false,  2     )

    @boll = [
      { name: "Price",  data: stock_price }, 
      { name: "Boll",   data: stave_boll  },
      { name: "Up",     data: stave_mup   },
      { name: "Down",   data: stave_mdn   }
    ]

    @lohas = [
      { name: "Price",  data: stock_price }, 
      { name: "Trend",  data: stave_trend },
      { name: "Up",     data: stave_up1   },
      { name: "Down",   data: stave_dn1   },
      { name: "Top",    data: stave_top   },
      { name: "Bottom", data: stave_bot   }
    ]

    @stock        = stock
  end

end
