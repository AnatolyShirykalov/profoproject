class CreateStages < ActiveRecord::Migration[5.1]
  def change
    create_table :stages do |t|
      t.string :name
      t.string :slug, unique: true
      t.text :content
      t.boolean :enabled, null: false, default: false
      t.integer :sort, unique: true
      t.references :tournament, foreign_key: true
      t.date :deadline

      t.timestamps
    end
  end
end
