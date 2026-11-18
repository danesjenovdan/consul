class Proposals::FeedbackComponent < ApplicationComponent
  attr_reader :resource_type, :response
  delegate :feedback, :errors, to: :response
  delegate :markdown, to: :helpers

  def initialize(resource_type, response = ProposalFeedback::Llm::Client::Response.new)
    @resource_type = resource_type
    @response = response
  end

  def render?
    ProposalFeedback::Llm::Client.enabled? && controller.class.module_parents.exclude?(Management)
  end

  private

    def button_text
      if feedback.present?
        t("proposals.feedback.refresh_feedback")
      else
        t("proposals.feedback.get_feedback")
      end
    end

    def feedback_html
      markdown(feedback, filter_html: true, no_images: true, no_links: true)
    end
end
