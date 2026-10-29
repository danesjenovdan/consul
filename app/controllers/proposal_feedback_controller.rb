class ProposalFeedbackController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check

  rate_limit to: 10,
             within: 15.minutes,
             by: -> { current_user.id },
             with: -> { render_rate_limit_response }

  def create
    @feedback = ProposalFeedback::Llm::Client.call(feedback_fields)

    respond_to do |format|
      format.js
    end
  end

  private

    def render_rate_limit_response
      @feedback = ProposalFeedback::Llm::Client::Response.new
      @feedback.errors << I18n.t("proposals.feedback.errors.rate_limit_exceeded")

      respond_to do |format|
        format.js { render :create }
      end
    end

    def feedback_fields
      {
        title: translation_params[:title],
        summary: translation_params[:summary],
        description: translation_params[:description],
        tags: resource_params[:tag_list]
      }
    end

    def resource_params
      @resource_params ||= params.require(params.require(:resource_type).parameterize.underscore)
                                 .permit(:tag_list, translations_attributes: [:title, :summary, :description])
    end

    def translation_params
      @translation_params ||= resource_params.require(:translations_attributes).values.find do |translation|
        translation.values.any?(&:present?)
      end || {}
    end
end
