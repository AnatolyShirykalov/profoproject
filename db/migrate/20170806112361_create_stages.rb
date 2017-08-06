class CreateStages < ActiveRecord::Migration[5.1]
  def change
    create_table :stages do |t|
      t.string :name
      t.text :content
      t.boolean :enabled, null: false, default: false
      t.integer :sort, unique: true
      t.references :tournament, foreign_key: true

      t.timestamps
    end
  end
end
