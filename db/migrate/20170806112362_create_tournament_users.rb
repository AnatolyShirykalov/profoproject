class CreateTournamentUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :tournament_users do |t|
      t.references :tournament, foreign_key: true
      t.references :user, foreign_key: true
      t.string :role
      t.boolean :enabled, null: false, default: false
      t.integer :sort, unique: true

      t.timestamps
    end
  end
end
