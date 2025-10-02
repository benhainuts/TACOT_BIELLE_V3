class MaintenanceItemsController < ApplicationController
  before_action :set_car
  before_action :set_maintenance_item, only: [:show, :edit, :update]

  def index
    # raise
    @maintenance_items = @car.maintenance_items
  end

  def index_from_picture
    set_image_data()
    @maintenance_items = @car.maintenance_items
    create_prompt()
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

  def set_image_data
    @imgdata=ImageDatum.find(params[:image_datum_id])
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
    #Listing des entretiens déja connus
    unassociated_items_presence = @imgdata.unassociated_items.any? if @imgdata
    # Liste des entretiens déjà faits ou à prévoir
    if @car.maintenance_items.any?
      in_plan = "entretiens_existants:" +
        @car.maintenance_items.each do |i|
          "- #{i.item_name}\n"
          # "- #{i.item_name}, tous les #{i.to_do_every_x_km} km ou #{i.to_do_every_x_years} an(s)"
        end.join("\n")
        + "- Les éléments listés dans entretiens_existants ne doivent JAMAIS apparaître ailleurs dans la réponse.\n"
    else
      in_plan = "entretiens_existants: aucun\n"
    end
    # Liste des entretiens dans la facture en cours d'intégration
    if unassociated_items_presence
      in_invoice = "entretiens_dans_facture:\n"+
        @imgdata.unassociated_items.map do |item|
          "- #{item[1]}"
        end
      .join("\n\n")
    else
      in_invoice = "entretiens_dans_facture : aucun.\n"
    end
    @maintenance_list = in_plan + in_invoice

    # Prompt
    #AJOUTER LES ENTRETIENS EXISTANTS, ON LES DEGAGERA A LA CREATION
    @prompt = <<~PROMPT
      "1/ CALCULER : A partir d'une liste d'entretiens existants et d'une liste d'entretiens présents dans une facture si donné, lister les nouveaux entretiens restants:

      Voiture #{@car.make} #{@car.model}, #{@car.energy}, #{@car.horsepower} ch,
      1ère immat: #{@car.first_registration_date}, #{@car.mileage} km, #{@car.mileage_per_year} km/an.

      #{@maintenance_list}

      nouveaux_entretiens : règles :
      - exemple [vidange huile; filtre à air; filtre carburant; filtre habitacle;
      courroie distribution; liquide frein; liquide refroidissement; pneus; embrayage; amortisseurs;
      révisions constructeur]
      - n'existent ni dans entretiens_dans_facture ni dans entretiens_existants, et ne sont pas similaires
      - ! ssi applicable au modele moteur et energie de la voiture #{@car.make} #{@car.model}, #{@car.energy} !
      - non exhaustif! inclure d'autres entretiens si besoin.

      2/ RESTITUER : uniquement nouveaux_entretiens et entretiens_dans_facture
      Réponse attendue : JSON -> array de hash
      - item_name: string ≤ 30 caractères
      - one_shot_operation: true/false
      - to_do_every_x_km: nombre ou null
      - to_do_every_x_years: nombre ou null
      - item_source : "entretiens_existants" ou "nouveaux_entretiens" ou "entretiens_dans_facture"


      Si erreur ou liste vide , renvoyer [].
    PROMPT
  end

  def create_plan
    create_prompt()
    # raise
    #prompt to chatGPT
    client = RubyLLM::Chat.new

      @response = client.ask(@prompt)
      # raise

    #Answerformat to an array of hashes
    array = JSON.parse(@response.content.gsub("```JSON","JSON"))
    # raise
    #For each line, create a new maintenance item in the PlanItem table
    array.each do |item|
      item.symbolize_keys!
      MaintenanceItem.create(car_id: @car.id, item_name: item[:item_name], to_do_every_x_km: item[:to_do_every_x_km], to_do_every_x_years: item[:to_do_every_x_years], one_shot_operation: item[:one_shot_operation]) if item[:item_source] != "entretiens_existants"
    end
  end

end
