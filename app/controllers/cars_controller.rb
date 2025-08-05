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

  def create_plan(car)
  #prompt to chatGPT
    client = RubyLLM::chat.new
    response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [{ role: "user", content:
      "une voiture de marque #{car.make} Modele #{car.model} carburant #{car.energy} puissance #{car.horsepower} de #{car.first_registration_date} avec #{car.mileage} km et faisant #{car.mileage_per_year} km par an.  liste moi dans un json chaque entretien a faire, avec au minimum si applicable (vidange huile/ filtre à air / filtre carburant / filtre d'habitable / courroie de distribution / liquide de frein / liquide de refroidissement / révision), avec des intitulés courts ( 30 caracteres max) selon le constructeur avec son nom dans name: sa périodicité en km dans to_do_every_x_km: et sa periodicite en année dans to_do_every_x_years. ne renvoie que ce json, si erreur renvoie ce json vide."}]
    })
  end

  #Answerformat to an array of hashes
  #For each line, create a new maintenance item in the PlanItem table
end
