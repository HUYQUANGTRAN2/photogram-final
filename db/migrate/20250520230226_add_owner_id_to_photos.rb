class AddOwnerIdToPhotos < ActiveRecord::Migration[7.1]
  def change
    add_column :photos, :owner_id, :integer
  end
end
