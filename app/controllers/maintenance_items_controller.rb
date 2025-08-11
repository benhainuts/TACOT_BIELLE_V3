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

  def call_maintenance
    create_plan()
    redirect_to maintenance_items_path(@car)
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

  def create_plan
    #JSON requis pour parser la réponse
    require 'json'
    #prompt to chatGPT
    client = RubyLLM::Chat.new
    if @car.maintenance_items.empty?
      response = client.ask(
        "une voiture de marque #{@car.make} Modele #{@car.model} carburant #{@car.energy} puissance #{@car.horsepower} de #{@car.first_registration_date} avec #{@car.mileage} km et faisant #{@car.mileage_per_year} km par an.  liste moi dans un json chaque entretien a faire, avec au minimum si applicable (vidange huile / filtre à air / filtre carburant / filtre d'habitable / courroie de distribution / liquide de frein / liquide de refroidissement / pneumatiques / filtre a essence / embrayage / amortisseurs / chaque révision recommandées avec le kilometrage ou l'année ET TOUTE AUTRE(S) OPERATION(S) NECESSAIRE(S) AU MODELE EN PARTICULIER), avec des intitulés courts ( 30 caracteres max) selon le constructeur avec son nom dans item_name: son caractere unique ou periodique dans one_shot_operation (true/false) sa périodicité/echeance en km dans to_do_every_x_km: et sa periodicite/echeance en année dans to_do_every_x_years. ne renvoie qu'un array de hash, si erreur renvoie un array vide."
      )
    else
      response = client.ask(
        "une voiture de marque #{@car.make} Modele #{@car.model} carburant #{@car.energy} puissance #{@car.horsepower} de #{@car.first_registration_date} avec #{@car.mileage} km et faisant #{@car.mileage_per_year} km par an. Elle a deja dans sa liste les items suivants: - vidange d'huile. liste moi dans un json chaque entretien supplémentaire a faire, avec au minimum si applicable (vidange huile / filtre à air / filtre carburant / filtre d'habitable / courroie de distribution / liquide de frein / liquide de refroidissement / pneumatiques / filtre a essence / embrayage / amortisseurs / chaque révision recommandées avec le kilometrage ou l'année ET TOUTE AUTRE(S) OPERATION(S) NECESSAIRE(S) AU MODELE EN PARTICULIER), avec des intitulés courts ( 30 caracteres max) selon le constructeur avec son nom dans item_name: son caractere unique ou periodique dans one_shot_operation (true/false) sa périodicité/echeance en km dans to_do_every_x_km: et sa periodicite/echeance en année dans to_do_every_x_years. ne renvoie qu'un array de hash, si erreur renvoie un array vide."
      )
    end
    #Answerformat to an array of hashes
    array = JSON.parse(response.content)
    #For each line, create a new maintenance item in the PlanItem table
    array.each do |item|
      item.symbolize_keys!
      MaintenanceItem.create(car_id: @car.id, item_name: item[:item_name], to_do_every_x_km: item[:to_do_every_x_km], to_do_every_x_years: item[:to_do_every_x_years], one_shot_operation: item[:one_shot_operation])
    end
  end

end
