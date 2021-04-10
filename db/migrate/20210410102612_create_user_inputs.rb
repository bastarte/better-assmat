class CreateUserInputs < ActiveRecord::Migration[6.1]
  def change
    create_table :user_inputs do |t|
      t.boolean :selected
      t.text :comment
      t.references :assmat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
