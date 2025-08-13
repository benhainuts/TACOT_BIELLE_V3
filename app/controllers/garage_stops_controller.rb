class GarageStopsController < ApplicationController
  before_action :set_car
  before_action :set_garage_stop, only: [:show, :edit, :update]

  def index
    @garage_stops = @car.garage_stops
  end


  def new
    @garage_stop = GarageStop.new
  end

  def create
    @garage_stop = GarageStop.new(garage_stop_params)
    # raise

    if @garage_stop.save
      redirect_to car_garage_stops_path(@car)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @garage_stop = GarageStop.find(params[:id])
  end

  def update
    if @garage_stop.update(garage_stop_params)
      redirect_to car_garage_stop_path(@car, @garage_stop)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show

  end


  def invoice_review
    #Analyse des images
      #pour chaque image
        #prompt lecture d'image à chat gpt
        #lecture plaque d'immatriculation
        #lecture marque
        #lecture modele
        #lecture carburant
        #lecture kilométrage
        #lecture des items d'entretiens

      # lancement du prompt pour chaque image
      #merge
    #si plaque connue
    #on met à jour le kilometrage si supérieur a kilométrage dans voiture
    #si le plan d'entretien est deja declaré
      #on demande a chat gpt
        #si les items peuvent etre associés a chaque ligne, on reprend l'intitulé
        #sinon, on crée un nouvel intitulé
      #on créé les nouveaux items si besoin
    #sinon
      #on tire les items de la facture
      #on ajoute les eventuels elements manquants parmi la liste

    #sinon
      #on a beosin d'un ajout manuel de la voiture
      #on tire les items de la facture
      #on ajoute les eventuels elements manquants parmi la liste
    #on créé le garage_stop
    #on declare le garage_stop_item
  end

  def image_reading_prompt()
    @prompt = <<~PROMPT
      Facture ou devis de réparation de véhicule.
      Réponse attendue : JSON -> array de hash :
      - invoice_number : numéro de facture : string ou null
      - number_plate: plaque d'immatriculation : string ≤ 30 caractères
      - make: constructeur : string ≤ 30 caractères ou null
      - model: modèle : string ≤ 30 caractères ou null
      - mileage : kilométrage : number ou null
      - energy : carburant : string ≤ 30 caractères ou null
      - maintenance_items : array avec chaque opération d'entretien détectée
      si ce n'est pas une facture pour un véhicule, renvoyer ["facture non reconnue"]
      si erreur, renvoyer [].
    PROMPT
  end

  def images_reading_request()
    raise
    images_set = params[:photos]
  end

private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def set_garage_stop
    @garage_stop = GarageStop.find(params[:id])
  end

  def garage_stop_params
    params.require(:garage_stop).permit(:car_id, :garage_id, :date, :mileage, :cost, :comments, :photos)
  end

end
