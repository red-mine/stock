class StocksController < ApplicationController
  def index
    @stock = Stock.where(code: "sz003019").pluck(:date, :price)
  end
end
