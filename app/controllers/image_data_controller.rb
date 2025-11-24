class ImageDataController < ApplicationController
before_action :set_image_data, only: [:show]
  def picture_analysis
    # params.require(:data.permit(:photos)
  end


  def invoice_review
    images_reading_request()
    if @consolidated_data[:number_plate].count > 1
      flash[:alert] = "Il y a plus de deux voitures sur l'analyse, veuillez recommencer"
      puts "erreur, les factures concernent plusieurs voitures"
      redirect_to  new_picture_analysis_path()
    else
      flash[:notice] = "image analysée avec succès"
      puts "image analysée avec succès"
    end
    #creation du stop
    #si plaque connue
    cleaned_plate = @consolidated_data[:number_plate][0].strip.delete("-,_")
    puts "CONTROLE DE L EXISTENCE DE LA VOITURE EN BASE"
    if
      @invoiced_car = Car.where("UPPER(REPLACE(REPLACE(REPLACE(REPLACE(number_plate, '-', ''), '_', ''), ',', ''), ' ', '')) = ?", cleaned_plate).first
      #on met à jour le kilometrage si supérieur a kilométrage dans voiture
      puts "=> voiture retrouvée"
      @invoiced_car.mileage = @consolidated_data[:mileage][0] if @invoiced_car.mileage < @consolidated_data[:mileage][0]
      @invoiced_car.save
      #si la voiture possède déjà un plan d'entretien, alors on matche les eventuelles lignes de factures qui correspondent à des lignes existantes.
      if @invoiced_car.maintenance_items.any?
        puts "plan d'entretien retrouvé"
        @existing_items = @invoiced_car.maintenance_items
      else
        puts "pas de plan d'entretien trouvé"
        @existing_items = []
      end
      @invoice_items = @consolidated_data[:maintenance_items]
      invoice_items_vs_plan_matching()
    else
      puts "=> voiture non retrouvée"
      flash[:notice] = "voiture non retrouvée, création de l'enregistrement"
      #construction de l'item matching NE PAS REPRENDRE LA FCT CHAT GPT
      @existing_items = []
      invoice_items_vs_plan_matching()
      redirect_to new_car_from_picture_path(@imgdata)
    end
    # raise

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
    #JSON requis pour parser la réponse
    require 'json'
    return <<~PROMPT
      app/helpers      Facture ou devis de réparation de véhicule.
      Réponse attendue : JSON => array de hash :
      - invoice_number : numéro de facture : string ou null
      - number_plate: plaque d'immatriculation : string ≤ 30 caractères ou null
      - make: constructeur : string ≤ 30 caractères ou null
      - model: modèle : string ≤ 30 caractères ou null
      - mileage : kilométrage : number ou null
      - energy : carburant : string ≤ 30 caractères ou null
      - maintenance_items : array de hash avec clé commençant par "i1", en incrémentant, avec chaque opération d'entretien détectée en utilisant si applicables des titres generiques, tels que par exemple : vidange huile; filtre à air; filtre carburant; filtre habitacle;
      courroie distribution; liquide frein; liquide refroidissement; pneus; embrayage; amortisseurs;
      révisions constructeur.
      - price : number ou null
      - date : date ou null
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
    images_set = params[:data][:photos]
    @read_data = []
    pagesnb=images_set.count
    images_set.each do |image, i|
      image_reading_chatgpt(image)
      @read_data << @response
      puts "Image #{i} on #{pagesnb} analyzed."
    end
    images_data_analysis_and_formatting(@read_data)
    consolidated_data_undoubling(@consolidated_data)
  end

  def images_data_analysis_and_formatting(read_data)
    @consolidated_data = {
      invoice_number: [],
      number_plate: [],
      make: [],
      model: [],
      mileage: [],
      energy: [],
      maintenance_items: [],
      price: [],
      date: []
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
        @consolidated_data[:maintenance_items].concat(page["maintenance_items"].to_a)  if page["maintenance_items"]
        @consolidated_data[:price]           << page["price"] #unless page["price"] = "null"
        @consolidated_data[:date]           << page["date"] #unless page["date"] = "null"
      end
    end
  end

  def consolidated_data_undoubling(consolidated_data)
    require 'json'
    consolidated_data.each  do |item_array|
      item_array.uniq!
    end
    puts "Image Data en creation"
    if @imgdata = ImageDatum.new(
      # user: current_user,
      user_id: "1",
      invoice_number: consolidated_data[:invoice_number][0],
      number_plate: consolidated_data[:number_plate][0],
      make: consolidated_data[:make][0],
      model: consolidated_data[:model][0],
      mileage: consolidated_data[:mileage][0],
      energy: consolidated_data[:energy][0],
      # maintenance_items: JSON.parse(consolidated_data[:maintenance_items]))
      maintenance_items: consolidated_data[:maintenance_items],
      price: consolidated_data[:price][0],
      date: consolidated_data[:date][0])
      @imgdata.save
      puts "Imagedata créée"
    else
      puts "Echec de la creation de l'image_data"
    end
  end

  def invoice_items_vs_plan_matching_prompt()
    require 'json'
    #constitution du prompt
    # Liste des entretiens déjà existants
    if !@existing_items.any?
        existing = "Pas d'entretien existant"
    else
      existing = "Déjà_listés:\n" +
        @existing_items.map do |i|
          "- #{i.item_name}, tous les #{i.to_do_every_x_km} km ou #{i.to_do_every_x_years} an(s), id_plan = #{i.id}"
        end.join("\n")
      end
    # Liste des entretiens identifiés dans la facture
    in_invoice = "Dans_la_facture:\n" +
      @invoice_items.map do |i|
        "- #{i.values[0]}, id_invoice = #{i.keys[0]} "
      end.join("\n")
    @item_matching_prompt = <<~PROMPT
      Associer chaque item de la facture avec les items existants (s'il existent) du plan d'entretien
      - Si un item de la facture correspond (même partiellement, par synonymie ou variante orthographique)
        à un item déjà listé, tu dois l'associer à cet item EXISTANT (et uniquement lui).
      - N'utiliser la liste générique (vidange huile, filtre à air, filtre carburant, filtre habitacle,
        etc. NON EXHAUSTIF) QUE si aucun équivalent n'existe déjà dans "Déjà listés".
      - Règle de priorité obligatoire :
        1. Si un item de la facture correspond à un item déjà listé, même avec variation de formulation
          (ex. pluriel/singulier, différence de mot mais même sens : "révisions constructeur" ≈ "Révision générale"),
          alors il DOIT être associé à cet item existant.
        2. Ce n’est que si aucun item similaire n’existe dans "Déjà listés" qu’il faut utiliser la liste générique.
        3. Si vraiment aucun entretien n’est reconnu, renvoyer ["pas d'opération d'entretien"].

      Réponse attendue : JSON => hash :
      - associated_items : array d'array [item dans_la_facture, id_invoice , item déjà_listé, id_plan]
      - unassociated_items : array d'array [item_dans_la_facture, id_invoice, correspondance générique, ""]
      - si erreur, renvoyer ["erreur"].

      Déjà listés:
      #{existing}
      Dans la facture:
      #{in_invoice}
    PROMPT
  end

  def invoice_items_vs_plan_matching()
    invoice_items_vs_plan_matching_prompt()
    #prompt to chatGPT
    client = RubyLLM::Chat.new
    @response = client.ask(@item_matching_prompt)
    # raise
    #Answerformat to an array of hashes
    @item_matching_array = JSON.parse(@response.content).symbolize_keys
    @imgdata.associated_items = @item_matching_array[:associated_items]
    @imgdata.unassociated_items = @item_matching_array[:unassociated_items]
    @imgdata.save
    # raise
  end

private

  def image_data_params()
    params.require(:data).permit(:invoice_number, :number_plate, :make, :model, :energy, :mileage, :maintenance_items, :price, :date, photos: []  )
  end

  def set_image_data()
    @imgdata = ImageDatum.find(params[:image_datum_id])
  end

end
