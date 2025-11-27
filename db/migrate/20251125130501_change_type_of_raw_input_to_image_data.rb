class ChangeTypeOfRawInputToImageData < ActiveRecord::Migration[7.1]
  def up
    # Convertir les anciennes valeurs : si raw_input est null => array vide
    execute <<~SQL
      ALTER TABLE image_data
      ALTER COLUMN raw_input
      TYPE text[]
      USING CASE
            WHEN raw_input IS NULL THEN ARRAY[]::text[]
            ELSE ARRAY[raw_input]::text[]
          END;
    SQL

    # Appliquer le DEFAULT après conversion
    change_column_default :image_data, :raw_input, from: nil, to: []
  end

  def down
    # Revenir à text simple
    execute <<~SQL
      ALTER TABLE image_data
      ALTER COLUMN raw_input
      TYPE text
      USING raw_input[1];
    SQL

    change_column_default :image_data, :raw_input, from: [], to: nil
  end

end
