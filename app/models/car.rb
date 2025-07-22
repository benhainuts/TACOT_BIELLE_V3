class Car < ApplicationRecord
  belongs_to :user
  has_many :maintenance_items
  has_many :garage_stops

  # validates :number_plate, presence: true, uniqueness: true
  # validates :model, presence: true
  # validates :make, presence: true
  # validates :mileage, presence: true
  # validates :first_registration_date, presence: true
  # validates :energy, presence: true
  # validates :horsepower, presence: true

  # validates , presence: true
  # validates :model, presence: true

  has_many :garage_stops
  has_many :maintenance_items

  ENERGIE = [
  { id: "essence",          label: "Essence" },
  { id: "diesel",           label: "Diesel" },
  { id: "hybrid",           label: "Hybride" },
  { id: "plug-in_hybrid",   label: "Hybride rechargeable" },
  { id: "electric",         label: "Electrique" },
  { id: "hybrid_diesel",    label: "Hybride-diesel" },
  { id: "hydrogen",         label: "Hydrogène" },
  { id: "lpg",              label: "GPL" },
  { id: "bioethanol",       label: "Bicarburation essence-éthanol"}
  ].freeze

  USES = [
  { id: "commute",          label: "Domicile-travail" },
  { id: "use_for_work",     label: "Outil de travail" },
  { id: "weekend",          label: "Week-ends" },
  { id: "winter_holidays",  label: "Vacances d'hiver" },
  { id: "spring_holidays",  label: "Vacances de printemps" },
  { id: "summer_holidays",  label: "Vacances d'été" },
  { id: "fall_holidays",    label: "Vacances d'automne" }
  ].freeze

end
