class AddStatusToBudgetInvestment < ActiveRecord::Migration[4.2]
  def change
    add_column :budget_investments, :status, :string
  end
end
