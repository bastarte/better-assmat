class CreateAssmats < ActiveRecord::Migration[6.1]
  def change
    create_table :assmats do |t|
      t.string :name
      t.string :address
      t.string :area
      t.date :last_update
      t.float :distance
      t.string :phone
      t.string :cell
      t.string :general_availability
      t.string :url

      t.timestamps
    end
  end
end
