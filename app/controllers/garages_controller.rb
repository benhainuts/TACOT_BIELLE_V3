class GaragesController < ApplicationController
  before_action :set_garage, only: [:show, :edit, :update]

  def index
    @garages = Garage.all
  end

  def show
  end

  def new
    @garage = Garage.new
  end

  def create
    @garage = Garage.new(garage_params)
    if @garage.save
      redirect_to garages_path()
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @garage.update(garage_params)
      redirect_to garage_path(@garage)
    else
      render :edit, status: :unprocessable_entity
    end
  end

private

  def set_garage
    @garage = Garage.find(params[:id])
  end

  def garage_params
    params.require(:garage).permit(:name, :address)
  end

end
