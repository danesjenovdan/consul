load Rails.root.join('app', 'controllers', 'valuation', 'budget_investments_controller.rb')

class Valuation::BudgetInvestmentsController < Valuation::BaseController

  def valuate
    if valid_price_params? && @investment.update(valuation_params)
      # we do not want to send any emails
      # if @investment.unfeasible_email_pending?
      #   @investment.send_unfeasible_email
      # end

      Activity.log(current_user, :valuate, @investment)
      notice = t("valuation.budget_investments.notice.valuate")
      redirect_to valuation_budget_budget_investment_path(@budget, @investment), notice: notice
    else
      render action: :edit
    end
  end

  private
    def restrict_access_to_assigned_items
      return if current_user.administrator? ||
                Budget::ValuatorAssignment.exists?(investment_id: params[:id],
                                                  valuator_id: current_user.valuator.id)

      # Find the valuator group assignment for the investment
      valuator_group_assignment = Budget::ValuatorGroupAssignment.find_by(investment_id: params[:id])

      #  Check if the valuator group assignment exists
      if valuator_group_assignment.present?
        vg_id = valuator_group_assignment.valuator_group_id

      #  Find all valuators in the Valuator Group
        valuators_in_group = Valuator.where(valuator_group_id: vg_id)

      #  Check if the current user is among the valuators in the group
        return if valuators_in_group.exists?(user_id: current_user.id)
      else
      #  If no specific assignment, check if the user belongs to any valuator group for the investment
        valuator_groups_for_investment = Budget::ValuatorGroupAssignment.where(investment_id: params[:id])
        user_valuator_groups = current_user.valuator.valuator_groups
      end

      return if (user_valuator_groups & valuator_groups_for_investment.map(&:valuator_group)).present?

      raise ActionController::RoutingError, "Not Found"
    end
end
