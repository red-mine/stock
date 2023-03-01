require "stave"

class StocksController < ApplicationController
  def index
    @stocks = StocksCoef.all
  end

  STAVE = 100
  LOHAS = 875 # 3 * 250 + 125 = 875

  def show
    stock = Stave::Stock.new("sz", LOHAS + STAVE)
    
    @stock_price  = stock.good_aver(params[:stock], 10).slice!(90, 876)
    @stave_move   = stock.good_aver(params[:stock], STAVE)
    @stave_mu     = stock.good_boll(params[:stock], STAVE, true)
    @stave_md     = stock.good_boll(params[:stock], STAVE, false)

    @stave_trend  = stock.good_trend(params[:stock])
    @stave_dn1    = stock.good_stave(params[:stock], true,  1)
    @stave_up1    = stock.good_stave(params[:stock], false, 1)
    @stave_dn2    = stock.good_stave(params[:stock], true,  2)
    @stave_up2    = stock.good_stave(params[:stock], false, 2)

    Rails.logger.info "@stock_price.size = #{@stock_price.size}"
    Rails.logger.info "@stave_trend.size = #{@stave_trend.size}"

    Rails.logger.info "@stock_price[LOHAS] = #{@stock_price[LOHAS]}"
    Rails.logger.info "@stave_trend[LOHAS] = #{@stave_trend[LOHAS]}"

    if @stock_price[LOHAS][1] > @stave_trend[LOHAS][1]
      Rails.logger.info "good stock"
    end

    @stocks = [
      {name: "price", data: @stock_price}, 
      {name: "trend", data: @stave_move},
      # {name: "up",    data: @stave_mu},
      # {name: "dn",    data: @stave_md}
    ]

    @staves = [
      {name: "price", data: @stock_price}, 
      {name: "trend", data: @stave_trend},
      # {name: "up",   data: @stave_up1},
      # {name: "dn",   data: @stave_dn1},
      # {name: "top",   data: @stave_up2},
      # {name: "bot",   data: @stave_dn2}
    ]

    @stock_code = params[:stock]
  end
end
