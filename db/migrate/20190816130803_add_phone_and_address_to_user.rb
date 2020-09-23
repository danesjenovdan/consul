class AddPhoneAndAddressToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :phone, :text
    add_column :users, :address, :text
  end
end
