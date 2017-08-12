class AddFieldMarkType < ActiveRecord::Migration[5.1]
  def change
  	add_column :mark_types, :min, :int
  	add_column :mark_types, :max, :int
  end
end
