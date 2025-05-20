class AddLikesCountToPhotos < ActiveRecord::Migration[7.1]
  def change
    add_column :photos, :likes_count, :integer
  end
end
