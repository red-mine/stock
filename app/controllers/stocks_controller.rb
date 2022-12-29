class StocksController < ApplicationController
  def index
    @stock = Stock.where(code: "sz003019").pluck(:date, :price)
  end
  def show
    @stock = Stock.where(code: params[:stock]).pluck(:date, :price)
    @code = params[:stock]
  end
end
