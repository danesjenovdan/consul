require_dependency Rails.root.join('app', 'controllers', 'admin', 'budget_investments_controller').to_s

class Admin::BudgetInvestmentsController < Admin::BaseController
  def budget_investment_params
    attributes = [:external_url, :heading_id, :administrator_id, :tag_list,
                  :q1, :q2, :q3, :q4, :q5, :q6,
                  :valuation_tag_list, :incompatible, :visible_to_valuators, :selected,
                  :milestone_tag_list, valuator_ids: [], valuator_group_ids: []]
    params.require(:budget_investment).permit(attributes, translation_params(Budget::Investment))
  end
end