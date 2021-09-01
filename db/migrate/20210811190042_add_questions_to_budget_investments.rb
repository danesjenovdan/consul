class AddQuestionsToBudgetInvestments < ActiveRecord::Migration[5.2]
  def change
    add_column :budget_investment_translations, :q0, :text
    add_column :budget_investment_translations, :q1, :text
    add_column :budget_investment_translations, :q2, :text
    add_column :budget_investment_translations, :q3, :text
    add_column :budget_investment_translations, :q4, :text
    add_column :budget_investment_translations, :q5, :text
    add_column :budget_investment_translations, :q6, :text
    add_column :budget_investment_translations, :q8, :text
    add_column :budget_investment_translations, :q9, :text
  end
end
