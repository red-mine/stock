class StocksController < ApplicationController

  SMOOTH  = 2 * Stave::WEEKS

  def index
    stock   = params[:stock]
    commit  = params[:commit]

    stave   = Stave::Stave.new(Stave::STOCK, years, stock)

    @stocks_stavs, @stavs_date = stave.good_index(stock, commit)
  end

  def show
    stock   = params[:stock]
    years   = params[:years]

    stave   = Stave::Stave.new(Stave::STOCK, years, stock)

    @stave, @boll, @years, @stock = stave.good_show(stock, years)
  end

end
