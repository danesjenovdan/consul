require "rails_helper"

describe Proposals::FeedbackDetailsComponent do
  it "renders the feedback as sanitized markdown hidden behind a toggle" do
    render_inline Proposals::FeedbackDetailsComponent.new("**Be specific**<script>alert('hacked')</script>")

    expect(page).to have_button "See more"
    expect(page).to have_css "[role='region'][aria-label='Feedback on your proposal'].hide strong",
                             exact_text: "Be specific"
    expect(page).not_to have_css "script"
  end
end
