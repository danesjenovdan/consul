class AddDataConsentOptionToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :data_consent, :boolean, null: false, default: false
  end
end
