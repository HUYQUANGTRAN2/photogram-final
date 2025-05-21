class RemovePrivateFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :private
  end
end
