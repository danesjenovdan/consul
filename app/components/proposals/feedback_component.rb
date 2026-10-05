class Proposals::FeedbackComponent < ApplicationComponent
  attr_reader :response
  delegate :feedback, :errors, to: :response
  delegate :markdown, to: :helpers

  def initialize(response = ProposalFeedback::Llm::Client::Response.new)
    @response = response
  end

  def render?
    ProposalFeedback::Llm::Client.enabled?
  end

  private

    def button_text
      if feedback.present?
        t("proposals.feedback.refresh_feedback")
      else
        t("proposals.feedback.get_feedback")
      end
    end
end
