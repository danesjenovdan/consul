require "rails_helper"

describe ProposalFeedbackController do
  let(:user) { create(:user) }
  let(:proposal_params) do
    {
      tag_list: "Environment, Trees",
      translations_attributes: {
        "0" => { title: "More trees", summary: "Greener city", description: "Plant trees" }
      }
    }
  end

  before do
    sign_in user
    ProposalFeedbackController.cache_store.clear
  end

  describe "POST create" do
    it "requests feedback for the proposal fields" do
      expect(ProposalFeedback::Llm::Client).to receive(:call).with(
        title: "More trees",
        summary: "Greener city",
        description: "Plant trees",
        tags: "Environment, Trees"
      ).and_return(ProposalFeedback::Llm::Client::Response.new)

      post :create, params: { proposal: proposal_params }, format: :js

      expect(response).to be_successful
    end

    it "raises an error when proposal params are missing" do
      expect do
        post :create, format: :js
      end.to raise_error(ActionController::ParameterMissing)
    end

    context "when rate limit is exceeded" do
      render_views

      before do
        Setting["llm.provider"] = "OpenAI"
        Setting["llm.model"] = "gpt-4o"
        Setting["llm.use_ai_proposal_feedback"] = true
        allow(ProposalFeedback::Llm::Client).to receive(:call)
                                            .and_return(ProposalFeedback::Llm::Client::Response.new)
      end

      it "renders rate limit error message" do
        10.times { post :create, params: { proposal: proposal_params }, format: :js }

        post :create, params: { proposal: proposal_params }, format: :js

        expect(response).to be_successful
        expect(response.body).to include "Please wait a few minutes before requesting new feedback."
      end

      it "does not affect other users" do
        10.times { post :create, params: { proposal: proposal_params }, format: :js }

        sign_in create(:user)
        post :create, params: { proposal: proposal_params }, format: :js

        expect(response).to be_successful
        expect(response.body).not_to include "Please wait a few minutes before requesting new feedback."
      end
    end
  end
end
