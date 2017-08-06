class CreateTournaments < ActiveRecord::Migration[5.1]
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :slug
      t.integer :sort, unique: true
      t.boolean :enabled, null: false, default: false

      t.timestamps
    end
  end
end
