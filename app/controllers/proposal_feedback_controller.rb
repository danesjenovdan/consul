class ProposalFeedbackController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check

  rate_limit to: 10,
             within: 15.minutes,
             by: -> { current_user.id },
             with: -> { render_rate_limit_response }

  def create
    @feedback = ProposalFeedback::Llm::Client.call(
      title: proposal_translation_params[:title],
      summary: proposal_translation_params[:summary],
      description: proposal_translation_params[:description],
      tags: proposal_feedback_params[:tag_list]
    )

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

    def proposal_feedback_params
      @proposal_feedback_params ||= params.require(:proposal)
                                          .permit(:tag_list,
                                                  translations_attributes: [:title, :summary, :description])
    end

    def proposal_translation_params
      proposal_feedback_params.require(:translations_attributes).values.first
    end
end
