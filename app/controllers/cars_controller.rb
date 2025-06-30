class CarsController < ApplicationController


  def index
    @cars = Car.all
  end

  def new
    @car = Car.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

end
