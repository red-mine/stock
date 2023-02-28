require "stave"

class StocksController < ApplicationController
  def index
    @stocks = StocksCoef.all
    @stave = STAVE
  end

  STAVE = 100

  def show
    stock = Stave::Stock.new("sz", 875 + STAVE)
    
    @stock_ma10   = stock.good_aver(params[:stock], 10).slice!(90, 876)
    @stave_ma     = stock.good_aver(params[:stock], STAVE)
    @stave_mu     = stock.good_boll(params[:stock], STAVE, true)
    @stave_md     = stock.good_boll(params[:stock], STAVE, false)

    @stave_trend  = stock.good_trend(params[:stock])
    @stave_up1    = stock.good_stave(params[:stock], true,  1)
    @stave_dn1    = stock.good_stave(params[:stock], false, 1)
    @stave_up2    = stock.good_stave(params[:stock], true,  2)
    @stave_dn2    = stock.good_stave(params[:stock], false, 2)

    Rails.logger.info "@stock_ma10.size  = #{@stock_ma10.size}"
    Rails.logger.info "@stave_trend.size = #{@stave_trend.size}"

    @stocks = [
      {name: "ma10",  data: @stock_ma10}, 
      {name: "ma",    data: @stave_ma},
      {name: "mu",    data: @stave_mu},
      {name: "md",    data: @stave_md}
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
