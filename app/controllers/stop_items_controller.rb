class StopItemsController < ApplicationController
  before_action :set_garage_stop_and_car
  # before_action :set_maintenance_item, only: [:show, :edit, :update]
  before_action :set_stop_item, only: [:show, :edit, :update]

  def index
    @stop_items = @garage_stop.stop_items
  end

  def show

  end

  def new
    @stop_item = StopItem.new
  end

  def create
    @stop_item = StopItem.new(stop_item_params)
    if @stop_item.save
      redirect_to car_garage_stop_stop_items_path(@garage_stop)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit

  end

  def update
        if @stop_item.update(stop_item_params)
      redirect_to car_garage_stop_stop_item_path(@garage_stop, @stop_item)
    else
      render :edit, status: :unprocessable_entity
    end
  end

private

  def set_garage_stop_and_car
    @garage_stop = GarageStop.find(params[:garage_stop_id])
    @car = @garage_stop.car
  end

  # def set_maintenance_item
  #   @maintenance_item = MaintenanceItem.find(params[:maintenance_item_id])
  # end

  def set_stop_item
    @stop_item = StopItem.find(params[:id])
  end

  def stop_item_params
    params.require(:stop_item).permit(:garage_stop_id, :maintenance_item_id, :price, :next_date_milestone, :next_km_milestone)
  end
end
