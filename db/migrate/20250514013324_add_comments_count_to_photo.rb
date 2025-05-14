class AddCommentsCountToPhoto < ActiveRecord::Migration[7.1]
  def change
    add_column :photos, :comments_count, :integer
  end
end
