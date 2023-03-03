require "stave"

class StocksController < ApplicationController

  WEEK            = 5
  YEAR            = 250
  STAVE           = 20  * WEEK
  LOHAS           = 3.5 * YEAR
  SMOOTH          = 10
  
  def initialize
    Rails.logger.info "LOHAS = #{LOHAS}"
  end

  def index
    @stocks       = StocksCoef.all
    stocks        = StocksCoef.arel_table
    @date         = @stocks.pluck(stocks[:date])[-1]
  end

  def show
    stocks        = Stave::Stock.new( "sz",   LOHAS + STAVE )
    stock         = params[:stock]
    @stock        = stock

    stock_price   = stocks.good_aver( stock,  SMOOTH        )
    stock_start   = STAVE - SMOOTH
    stock_end     = LOHAS + 1
    stock_price   = stock_price.slice!(stock_start, stock_end)

    @stave_boll   = stocks.good_aver( stock,  STAVE         )
    @stave_mup    = stocks.good_boll( stock,  STAVE,  true  )
    @stave_mdn    = stocks.good_boll( stock,  STAVE,  false )

    @stave_trend  = stocks.good_trend(stock                 )
    @stave_up1    = stocks.good_stave(stock,  true,   1     )
    @stave_dn1    = stocks.good_stave(stock,  false,  1     )
    @stave_top    = stocks.good_stave(stock,  true,   2     )
    @stave_bot    = stocks.good_stave(stock,  false,  2     )

    @stocks = [
      {name: "Price",   data:  stock_price}, 
      {name: "Boll",    data: @stave_boll },
      {name: "Up",      data: @stave_mup  },
      {name: "Down",    data: @stave_mdn  }
    ]

    @staves = [
      {name: "Price",   data:  stock_price}, 
      {name: "Trend",   data: @stave_trend},
      {name: "Up",      data: @stave_up1  },
      {name: "Down",    data: @stave_dn1  },
      {name: "Top",     data: @stave_top  },
      {name: "Bottom",  data: @stave_bot  }
    ]
  end

end
