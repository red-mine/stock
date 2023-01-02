require "stave"

class StocksController < ApplicationController
  def index
    # stock_data = Stock.where(code: "sz003019").pluck(:date, :price)
    # trend_line = 
    # @stocks = 
  end
  def show
    stock = Stave::Stock.new("sz")
    @stock_ma10   = stock.good_data_aver(params[:stock], 10 )
    @stock_ma100  = stock.good_data_aver(params[:stock], 100)
    @stock_mu100  = stock.good_data_updn(params[:stock], 100, true)
    @stock_md100  = stock.good_data_updn(params[:stock], 100, false)
    @stocks = [
      {name: "ma10",  data: @stock_ma10}, 
      {name: "ma100", data: @stock_ma100},
      {name: "mu100", data: @stock_mu100},
      {name: "md100", data: @stock_md100}
    ]
    @stock_code = params[:stock]
  end
end
