class CarsController < ApplicationController
before_action :set_car, only: [:show, :edit, :update]
# before_action :car_params, only: [:create]

  def index
    @cars = Car.all
  end

  def new
    @car = Car.new
  end

  def create
    # puts car_params.inspect

    @car = Car.new(car_params)
    # @car.use = params[:car][:use].to_s
    # raise
    if @car.save
      # raise
      redirect_to cars_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    # raise
  end

  def update
    # raise
    if @car.update(car_params)
      redirect_to car_path(@car)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
  end

  # private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:user_id, :number_plate, :make, :model, :energy, :horsepower, :first_registration_date, :mileage, :mileage_per_year, :use, :last_technical_control_date, :last_maintenance_operation_made_on, :last_maintenance_operation_mileage, :energy, use: [])
  end

end
