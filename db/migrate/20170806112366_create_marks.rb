class CreateMarks < ActiveRecord::Migration[5.1]
  def change
    create_table :marks do |t|
      t.references :mark_type, foreign_key: true
      t.references :photo, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :mark, null: false, default: 0
      t.text :content, null: false, default: ''
      t.attachment :image1
      t.attachment :image2

      t.timestamps
    end
    add_index :marks, %i[mark_type_id photo_id user_id], unique: true
  end
end
