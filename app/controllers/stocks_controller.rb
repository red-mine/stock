require "stave"

class StocksController < ApplicationController
  def index
    @stocks = StocksCoef.all
  end

  STAVE = 100 # 20 * WW(5) = 100
  LOHAS = 875

  def show
    stock = Stave::Stock.new("sz", LOHAS + STAVE)
    
    @stock_price  = stock.good_aver(params[:stock], 10).slice!(STAVE - 10, LOHAS + 1)

    @stave_boll   = stock.good_aver(params[:stock], STAVE)
    @stave_mup    = stock.good_boll(params[:stock], STAVE, true)
    @stave_mdn    = stock.good_boll(params[:stock], STAVE, false)

    @stave_trend  = stock.good_trend(params[:stock])
    @stave_up1    = stock.good_stave(params[:stock], false, 1)
    @stave_dn1    = stock.good_stave(params[:stock], true,  1)
    @stave_top    = stock.good_stave(params[:stock], false, 2)
    @stave_bot    = stock.good_stave(params[:stock], true,  2)

    @stocks = [
      {name: "price", data: @stock_price}, 
      {name: "boll",  data: @stave_boll},
      {name: "up",    data: @stave_mup},
      {name: "dn",    data: @stave_mdn}
    ]

    @staves = [
      {name: "price", data: @stock_price}, 
      {name: "trend", data: @stave_trend},
      {name: "up",    data: @stave_up1},
      {name: "dn",    data: @stave_dn1},
      {name: "top",   data: @stave_top},
      {name: "bot",   data: @stave_bot}
    ]

    @stock_code = params[:stock]
  end
end
