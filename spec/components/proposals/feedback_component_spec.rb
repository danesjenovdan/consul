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

    render_inline Proposals::FeedbackComponent.new

    expect(page).not_to be_rendered
  end

  it "is not rendered when the feature is disabled" do
    Setting["llm.use_ai_proposal_feedback"] = false

    render_inline Proposals::FeedbackComponent.new

    expect(page).not_to be_rendered
  end

  it "renders a button to get feedback" do
    render_inline Proposals::FeedbackComponent.new

    expect(page).to have_content "Want to improve this proposal before submitting it?"
    expect(page).to have_button "Get feedback"
    expect(page).not_to have_css ".proposal-feedback-content"
  end

  it "renders the feedback as sanitized markdown and a button to refresh it" do
    response.feedback = "**Be more specific**<script>alert('hacked')</script>"

    render_inline Proposals::FeedbackComponent.new(response)

    expect(page).to have_css "[role='region'][aria-label='Feedback on your proposal'] strong",
                             exact_text: "Be more specific"
    expect(page).not_to have_css "script"
    expect(page).to have_button "Refresh feedback"
  end

  it "renders errors" do
    response.errors << "LLM error"

    render_inline Proposals::FeedbackComponent.new(response)

    expect(page).to have_css "[role='alert']", text: "LLM error"
  end
end
