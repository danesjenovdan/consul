class AddUserFieldsToProposal < ActiveRecord::Migration[4.2]
  def change
    # naredi stolpce v bazi v tabeli budget_investments
    add_column :budget_investments, :user_name, :text, null: true
    add_column :budget_investments, :user_last_name, :text, null: true
    add_column :budget_investments, :user_address, :text, null: true
	add_column :budget_investments, :user_contact, :text, null: true
  end
end