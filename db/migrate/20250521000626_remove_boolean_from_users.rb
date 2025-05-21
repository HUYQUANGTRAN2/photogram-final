class RemoveBooleanFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :boolean
  end
end
