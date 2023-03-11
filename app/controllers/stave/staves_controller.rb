module Stave
  class StavesController < ApplicationController
    before_action :set_stave, only: %i[ show edit update destroy ]

    # GET /staves
    def index
      @staves = Stave.all
    end

    # GET /staves/1
    def show
    end

    # GET /staves/new
    def new
      @stave = Stave.new
    end

    # GET /staves/1/edit
    def edit
    end

    # POST /staves
    def create
      @stave = Stave.new(stave_params)

      if @stave.save
        redirect_to @stave, notice: "Stave was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /staves/1
    def update
      if @stave.update(stave_params)
        redirect_to @stave, notice: "Stave was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /staves/1
    def destroy
      @stave.destroy
      redirect_to staves_url, notice: "Stave was successfully destroyed."
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_stave
        @stave = Stave.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def stave_params
        params.require(:stave).permit(:stock, :price, :date, :years)
      end
  end
end
