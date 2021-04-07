class CreateAvailabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :availabilities do |t|
      t.string :description
      t.string :details
      t.string :calendar
      t.references :assmat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
