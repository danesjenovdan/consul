class DjndAddConsentToPublishNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :consent_to_publish_name, :boolean
  end
end
