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

  def picture_analysis
    # params.require(:garage_stop).permit(:photos)
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
    images_reading_request()

    #si plaque connue
    cleaned_plate = @consolidated_data[:number_plate][0].strip.delete("-,_")
    if Car.where("UPPER(REPLACE(REPLACE(REPLACE(REPLACE(number_plate, '-', ''), '_', ''), ',', ''), ' ', '')) = ?", cleaned_plate).first
      @invoiced_car = Car.where("UPPER(REPLACE(REPLACE(REPLACE(REPLACE(number_plate, '-', ''), '_', ''), ',', ''), ' ', '')) = ?", cleaned_plate).first
      #on met à jour le kilometrage si supérieur a kilométrage dans voiture
      puts "voiture retrouvée"
      @invoiced_car.mileage = @consolidated_data[:mileage][0] if @car.mileage < @consolidated_data[:mileage][0]
      @invoiced_car.save

      if @invoiced_car.maintenance_items.exists?
        existing_items = @invoiced_car.maintenance_items
        invoice_items = @consolidated_data[:maintenance_items]
        #on demande a chat gpt
        #si les items peuvent etre associés a chaque ligne, on reprend l'intitulé
        #sinon, on crée un nouvel intitulé
      #on créé les nouveaux items si besoinraise
      end



    end
    raise

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
    return <<~PROMPT
app/helpers      Facture ou devis de réparation de véhicule.
      Réponse attendue : JSON => array de hash :
      - invoice_number : numéro de facture : string ou null
      - number_plate: plaque d'immatriculation : string ≤ 30 caractères ou null
      - make: constructeur : string ≤ 30 caractères ou null
      - model: modèle : string ≤ 30 caractères ou null
      - mileage : kilométrage : number ou null
      - energy : carburant : string ≤ 30 caractères ou null
      - maintenance_items : array avec chaque opération d'entretien détectée en utilisant si applicables des titres generiques, tels que par exemple : vidange huile; filtre à air; filtre carburant; filtre habitacle;
      courroie distribution; liquide frein; liquide refroidissement; pneus; embrayage; amortisseurs;
      révisions constructeur.
      si ce n'est pas une facture pour un véhicule, renvoyer ["facture non reconnue"]
      si erreur, renvoyer [].
    PROMPT
  end

  def image_reading_chatgpt(image)
    # client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    # base64_image = Base64.encode64(image.read)
    chat = RubyLLM.chat(model: 'gpt-4o') # vision-capable model
    prompt = image_reading_prompt()

    request = chat.ask image_reading_prompt(), with: { image: image }
    @raw = request.content
    @response = JSON.parse(@raw.gsub(/```json|```/, "").strip)
  end

  def images_reading_request()
    # raise
    images_set = params[:garage_stop][:photos]
    @read_data = []
    pagesnb=images_set.count
    images_set.each do |image, i|
      image_reading_chatgpt(image)
      @read_data << @response
      puts "Image #{i} on #{pagesnb} analyzed."
    end
    images_data_analysis_and_formatting(@read_data)
    consolidated_data_undoubling(@consolidated_data)

    if @consolidated_data[:number_plate].count > 1
      redirect_to  new_car_garage_stop_picture_analysis_path(@car), status: :unprocessable_entity
    end

  end

  def images_data_analysis_and_formatting(read_data)
    @consolidated_data = {
      invoice_number: [],
      number_plate: [],
      make: [],
      model: [],
      mileage: [],
      energy: [],
      maintenance_items: []
    }

    read_data.each do |page|
      page = page[0]
      unless page == "facture non reconnue"
        @consolidated_data[:invoice_number]   << page["invoice_number"] #unless page["invoice_number"] = "null"
        @consolidated_data[:number_plate]     << page["number_plate"] #unless page["number_plate"] = "null"
        @consolidated_data[:make]             << page["make"] #unless page["make"] = "null"
        @consolidated_data[:model]            << page["model"] #unless page["model"] = "null"
        @consolidated_data[:mileage]          << page["mileage"] #unless page["mileage"] = "null"
        @consolidated_data[:energy]           << page["energy"] #unless page["energy"] = "null"
        @consolidated_data[:maintenance_items].concat(page["maintenance_items"])  if page["maintenance_items"]
      end
    end
  end

  def consolidated_data_undoubling(consolidated_data)
    consolidated_data.each  do |item_array|
      item_array.uniq!
    end
    puts "Image Data en creation"
    if imgdata = ImageDatum.new(
      # user: current_user,
      user_id: "1",
      invoice_number: consolidated_data[:invoice_number],
      number_plate: consolidated_data[:number_plate],
      make: consolidated_data[:make],
      model: consolidated_data[:model],
      mileage: consolidated_data[:mileage],
      energy: consolidated_data[:energy],
      maintenance_items: consolidated_data[:maintenance_items])

      imgdata.save
      puts "Imagedata créée"
    else
      puts "Echec de la creation de l'image"
    end

  end

  def maintenance_item_review_prompt(existing_items , invoice_items)

    #integrer le prompt a chat gpt
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
