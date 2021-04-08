class AddCoordinatesToAssmats < ActiveRecord::Migration[6.1]
  def change
    add_column :assmats, :latitude, :float
    add_column :assmats, :longitude, :float
  end
end
