require "rails_helper"

describe Proposals::FeedbackComponent do
  let(:response) { ProposalFeedback::Llm::Client::Response.new }

  before do
    Setting["llm.provider"] = "OpenAI"
    Setting["llm.model"] = "gpt-4o"
    Setting["llm.use_ai_proposal_feedback"] = true
  end

  it "is not rendered when the LLM is not configured" do
    Setting["llm.model"] = nil

    render_inline Proposals::FeedbackComponent.new("Proposal")

    expect(page).not_to be_rendered
  end

  it "is not rendered when the feature is disabled" do
    Setting["llm.use_ai_proposal_feedback"] = false

    render_inline Proposals::FeedbackComponent.new("Proposal")

    expect(page).not_to be_rendered
  end

  it "is not rendered in the management section" do
    with_controller_class Management::BaseController do
      render_inline Proposals::FeedbackComponent.new("Proposal")

      expect(page).not_to be_rendered
    end
  end

  it "renders a button to get feedback and an empty results area" do
    render_inline Proposals::FeedbackComponent.new("Proposal")

    expect(page).to have_css ".proposal-feedback[data-resource-type='Proposal']"
    expect(page).to have_css "h2", exact_text: "Want to improve this proposal before submitting it?"
    expect(page).to have_button "Get feedback", class: "button"
    expect(page).not_to have_button class: "hollow"
    expect(page).to have_css ".proposal-feedback-results[aria-live='polite']"
    expect(page).not_to have_css ".proposal-feedback-results *"
  end

  it "renders the feedback as a list and a button to refresh it" do
    response.feedback = "- **Title is brief: Met.** It says what and where.\n" \
                        "- **Summary says what is proposed: Not met.** Add why."

    render_inline Proposals::FeedbackComponent.new("Proposal", response)

    expect(page).to have_button "Refresh feedback"

    page.find(".proposal-feedback-results") do |results|
      expect(results).to have_css "h3", exact_text: "Evaluation against criteria"
      expect(results).to have_css "li", count: 2
      expect(results).to have_css "li strong", exact_text: "Title is brief: Met."
      expect(results).to have_content "It says what and where."
    end
  end

  it "does not render links, images or HTML from the feedback" do
    response.feedback = "- **Title: Met.** [Click](https://example.com) ![](https://example.com/a.png) " \
                        "<script>alert('x')</script><h1>Big</h1>"

    render_inline Proposals::FeedbackComponent.new("Proposal", response)

    expect(page).not_to have_link
    expect(page).not_to have_css "img"
    expect(page).not_to have_css "script", visible: :all
    expect(page).not_to have_css "h1"
  end

  it "renders errors in the results area" do
    response.errors << "LLM error"

    render_inline Proposals::FeedbackComponent.new("Proposal", response)

    expect(page).to have_css ".proposal-feedback-results .error", exact_text: "LLM error"
    expect(page).to have_button "Get feedback"
  end
end
