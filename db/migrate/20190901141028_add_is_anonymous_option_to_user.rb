class AddIsAnonymousOptionToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :is_anonymous, :boolean, null: false, default: false
  end
end
