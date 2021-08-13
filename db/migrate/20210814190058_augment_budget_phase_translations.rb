class AugmentBudgetPhaseTranslations < ActiveRecord::Migration[4.2]
    def change
      add_column :budget_phase_translations, :presentation_summary_1, :string
      add_column :budget_phase_translations, :presentation_summary_2, :string
      add_column :budget_phase_translations, :presentation_summary_3, :string
    end
  end
  