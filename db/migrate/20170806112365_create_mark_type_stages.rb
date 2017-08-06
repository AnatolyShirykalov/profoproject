class CreateMarkTypeStages < ActiveRecord::Migration[5.1]
  def change
    create_table :mark_type_stages do |t|
      t.references :stage, foreign_key: true
      t.references :mark_type, foreign_key: true
      t.boolean :enabled, null: false, default: false
      t.integer :sort, unique: true

      t.timestamps
    end
  end
end
