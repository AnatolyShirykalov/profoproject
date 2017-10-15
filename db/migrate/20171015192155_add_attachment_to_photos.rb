class AddAttachmentToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_attachment :photos, :photo1
    add_attachment :photos, :photo2
  end
end
