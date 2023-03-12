class StocksController < ApplicationController

  def index
    stock   = params[:stock]
    commit  = params[:commit]

    stave   = Stave::Lohas.new(Stave::STOCK, nil, stock)

    @stocks_stavs, @stavs_date = stave.good_index(stock, commit)
  end

  def show
    stock   = params[:stock]
    years   = params[:years]

    @stock  = stock

    stave   = Stave::Lohas.new(Stave::STOCK, years, stock)

    @stave, @boll, @years = stave.good_show(stock, years)
  end

end
