class AddExtraQuestionsToBudgetForm < ActiveRecord::Migration[4.2]
  def change
    add_column :budget_investments, :q1, :text, null: true
    add_column :budget_investments, :q2, :text, null: true
    add_column :budget_investments, :q3, :text, null: true
    add_column :budget_investments, :q4, :text, null: true
    add_column :budget_investments, :q5, :text, null: true
    add_column :budget_investments, :q6, :text, null: true
    add_column :budget_investments, :q7, :text, null: true
  end
end
