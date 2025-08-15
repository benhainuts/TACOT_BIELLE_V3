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
    raise
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

  def create_prompt
    #JSON requis pour parser la réponse
    require 'json'
    #constitution du prompt
    # Liste des entretiens déjà faits ou à prévoir
    if @car.maintenance_items.any?
      maintenance_list = "Déjà listés:\n" +
        @car.maintenance_items.map do |i|
          "- #{i.item_name}, tous les #{i.to_do_every_x_km} km ou #{i.to_do_every_x_years} an(s)"
        end.join("\n") +
        "\nListe les entretiens supplémentaires (non présents ci-dessus) si applicables :"
    else
      maintenance_list = "Liste exhaustive des entretiens à prévoir :"
    end

    # Prompt
    @prompt = <<~PROMPT
      Voiture #{@car.make} #{@car.model}, #{@car.energy}, #{@car.horsepower} ch,
      1ère immat: #{@car.first_registration_date}, #{@car.mileage} km, #{@car.mileage_per_year} km/an.

      #{maintenance_list}

      Inclure si applicable : vidange huile; filtre à air; filtre carburant; filtre habitacle;
      courroie distribution; liquide frein; liquide refroidissement; pneus; embrayage; amortisseurs;
      révisions constructeur; autres opérations spécifiques modèle.

      Réponse attendue : JSON -> array de hash :
      - item_name: string ≤ 30 caractères
      - one_shot_operation: true/false
      - to_do_every_x_km: nombre ou null
      - to_do_every_x_years: nombre ou null

      Si erreur, renvoyer [].
    PROMPT
  end

  def create_plan
    create_prompt()
    #prompt to chatGPT
    client = RubyLLM::Chat.new

      @response = client.ask(@prompt)
      # raise

    #Answerformat to an array of hashes
    array = JSON.parse(@response.content)
    raise
    #For each line, create a new maintenance item in the PlanItem table
    array.each do |item|
      item.symbolize_keys!
      MaintenanceItem.create(car_id: @car.id, item_name: item[:item_name], to_do_every_x_km: item[:to_do_every_x_km], to_do_every_x_years: item[:to_do_every_x_years], one_shot_operation: item[:one_shot_operation])
    end
  end

end
