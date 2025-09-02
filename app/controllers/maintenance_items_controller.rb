class MaintenanceItemsController < ApplicationController
  before_action :set_car
  before_action :set_maintenance_item, only: [:show, :edit, :update]

  def index
    # raise
    @maintenance_items = @car.maintenance_items
  end

  def show

  end

  def new
    # raise
    @maintenance_item = MaintenanceItem.new
  end

  def create
    @maintenance_item = MaintenanceItem.new(maintenance_item_params)
    @maintenance_item.car_id = @car.id
    if @maintenance_item.save
      redirect_to car_maintenance_items_path(@car)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end


  def update
    if @maintenance_item.update(maintenance_item_params)
      redirect_to car_maintenance_item_path(@car, @maintenance_item)
    else
      # raise
      render :edit, status: :unprocessable_entity
    end
  end

private

  def set_car
    @car=Car.find(params[:car_id])
  end

  def maintenance_item_params
    params.require(:maintenance_item).permit(:car_id, :item_name, :to_do_every_x_km, :to_do_every_x_years, :one_shot_operation)
  end

  def set_maintenance_item
    @maintenance_item = MaintenanceItem.find(params[:id])
  end

end
