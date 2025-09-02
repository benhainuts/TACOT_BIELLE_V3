class GarageStopsController < ApplicationController
  before_action :set_car
  before_action :set_garage_stop, only: [:show, :edit, :update]

  def index
    @garage_stops = @car.garage_stops
  end


  def new
    @garage_stop = GarageStop.new
  end

  def create
    @garage_stop = GarageStop.new(garage_stop_params)
    # raise

    if @garage_stop.save
      redirect_to car_garage_stops_path(@car)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @garage_stop = GarageStop.find(params[:id])
  end

  def update
    if @garage_stop.update(garage_stop_params)
      redirect_to car_garage_stop_path(@car, @garage_stop)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show

  end


private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def set_garage_stop
    @garage_stop = GarageStop.find(params[:id])
  end

  def garage_stop_params
    params.require(:garage_stop).permit(:car_id, :garage_id, :date, :mileage, :cost, :comments)
  end

end
