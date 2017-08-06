class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.string :name
      t.string :slug, unique: true
      t.string :description
      t.string :target
      t.attachment :photo
      t.references :stage, foreign_key: true
      t.references :user, foreign_key: true
      t.boolean :enabled, null: false, default: false
      t.integer :sort, unique: true

      t.timestamps
    end
  end
end
