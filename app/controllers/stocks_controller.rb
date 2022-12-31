require "stave"

class StocksController < ApplicationController
  def index
    # stock_data = Stock.where(code: "sz003019").pluck(:date, :price)
    # trend_line = 
    # @stocks = 
  end
  def show
    @stock = Stave::Stock.data(params[:stock]).pluck(:date, :price)
    @code = params[:stock]
  end
end
