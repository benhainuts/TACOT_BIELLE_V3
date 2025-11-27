class CarsController < ApplicationController
before_action :set_car, only: [:show, :edit, :update]
# before_action :car_params, only: [:create]

  def index
    @cars = Car.all
  end

  def new
    @car = Car.new
  end

  def new_from_picture
    set_image_data()
    @car = Car.new
    @car.number_plate = @imgdata.number_plate
    @car.make = @imgdata.make
    @car.model = @imgdata.model
    @car.mileage = @imgdata.mileage
    @car.energy = @imgdata.energy
  end

  def create
    # puts car_params.inspect
    @car = Car.new(car_params)
    # @car.use = params[:car][:use].to_s
    # raise
    if @car.save
      # raise
      redirect_to cars_path()
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create_from_picture
    set_image_data()
    @car = Car.new(car_params)
    # @car.use = params[:car][:use].to_s
    # raise
    if @car.save
      # raise
      redirect_to new_maintenance_plan_from_picture_path(@imgdata,@car)
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

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def set_image_data
    @imgdata=ImageDatum.find(params[:image_datum_id])
  end

  def car_params
    params.require(:car).permit(:user_id, :number_plate, :make, :model, :energy, :horsepower, :first_registration_date, :mileage, :mileage_per_year, :use, :last_technical_control_date, :last_maintenance_operation_made_on, :last_maintenance_operation_mileage, :energy, use: [])
  end

end
