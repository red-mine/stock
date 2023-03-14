module Stave
  class StavesController < ApplicationController
    before_action :set_stafe, only: %i[ show edit update destroy ]

    # GET /staves
    def index
      @staves = Stave.all
    end

    # GET /staves/1
    def show
    end

    # GET /staves/new
    def new
      @stafe = Stave.new
    end

    # GET /staves/1/edit
    def edit
    end

    # POST /staves
    def create
      @stafe = Stave.new(stafe_params)

      if @stafe.save
        redirect_to @stafe, notice: "Stave was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /staves/1
    def update
      if @stafe.update(stafe_params)
        redirect_to @stafe, notice: "Stave was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /staves/1
    def destroy
      @stafe.destroy
      redirect_to staves_url, notice: "Stave was successfully destroyed."
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_stafe
        @stafe = Stave.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def stafe_params
        params.require(:stave).permit(:stock, :price, :date, :years)
      end
  end
end
