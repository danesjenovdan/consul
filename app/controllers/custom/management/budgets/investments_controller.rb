load Rails.root.join("app", "controllers", "management", "budgets", "investments_controller.rb")

class Management::Budgets::InvestmentsController < Management::BaseController

  def new
    @investment.budget.questions.order(:id).each do |question|
      answer = @investment.answers.build({budget_id: @investment.budget.id, budget_question_id: question.id})
    end
  end

  private

    def investment_params
        attributes = [:heading_id, :tag_list, :organization_name, :location,
                      :terms_of_service, :related_sdg_list, :price,
                      answers_attributes: [:id, :text, :budget_id, :investment_id, :budget_question_id],
                      image_attributes: image_attributes,
                      documents_attributes: document_attributes,
                      map_location_attributes: map_location_attributes]
        params.require(:budget_investment).permit(attributes, translation_params(Budget::Investment))
      end
end
