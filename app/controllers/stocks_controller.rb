require "stave"

class StocksController < ApplicationController
  def index
    # stock_data = Stock.where(code: "sz003019").pluck(:date, :price)
    # trend_line = 
    # @stocks = 
  end
  def show
    stock = Stave::Stock.new("sz")
    @stock_data   = stock.good_data_data(params[:stock]     ).pluck(:date, :price)
    @stock_ma5    = stock.good_data_aver(params[:stock], 5  ).pluck(:date, :price)
    @stock_ma10   = stock.good_data_aver(params[:stock], 10 ).pluck(:date, :price)
    @stock_ma100  = stock.good_data_aver(params[:stock], 100).pluck(:date, :price)
    @stocks = [{name: "ma10", data: @stock_ma10}, {name: "ma100", data: @stock_ma100}]
    @stock_code = params[:stock]
  end
end
