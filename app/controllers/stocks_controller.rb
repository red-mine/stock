require "stave"

class StocksController < ApplicationController
  def index
    @stock = Stock.where(code: "sz003019").pluck(:date, :price)
  end
  def show
    @stock = Stave::Stock.data(params[:stock]).pluck(:date, :price)
    @code = params[:stock]
  end
end
