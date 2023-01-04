require "stave"

class StocksController < ApplicationController
  def index
    @stocks = StocksCoef.all
  end
  def show
    stock = Stave::Stock.new("sz")
    @stock_ma10   = stock.good_data_aver(params[:stock], 10 )
    @stock_ma100  = stock.good_data_aver(params[:stock], 100)
    @stock_mu100  = stock.good_data_updn(params[:stock], 100, true)
    @stock_md100  = stock.good_data_updn(params[:stock], 100, false)
    @stave_trend  = stock.good_data_trend(params[:stock])
    @stave_up1    = stock.good_stave_updn(params[:stock], true,  1)
    @stave_dn1    = stock.good_stave_updn(params[:stock], false, 1)
    @stave_up2    = stock.good_stave_updn(params[:stock], true,  2)
    @stave_dn2    = stock.good_stave_updn(params[:stock], false, 2)
    @stocks = [
      {name: "ma10",  data: @stock_ma10}, 
      {name: "ma100", data: @stock_ma100},
      {name: "mu100", data: @stock_mu100},
      {name: "md100", data: @stock_md100}
    ]
    @staves = [
      {name: "ma10",  data: @stock_ma10}, 
      {name: "trend", data: @stave_trend},
      {name: "up1",   data: @stave_up1},
      {name: "dn1",   data: @stave_dn1},
      {name: "up2",   data: @stave_up2},
      {name: "dn2",   data: @stave_dn2}
    ]
    @stock_code = params[:stock]
  end
end
