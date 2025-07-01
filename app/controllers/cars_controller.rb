class CarsController < ApplicationController
before_action :set_car, only: [:show]
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
    if @car.save
      redirect_to cars_path
    else
       render :new, status: :unprocessable_entity
    end
  end

  def show

  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.permit(:user_id, :number_plate, :make, :model, :energy, :horsepower, :first_registration_date, :mileage, :mileage_per_year, :use, :last_technical_control_date, :last_maintenance_operation_made_on, :last_maintenance_operation_mileage)
  end

end
