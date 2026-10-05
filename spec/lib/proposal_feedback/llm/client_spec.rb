require "rails_helper"

describe ProposalFeedback::Llm::Client do
  describe ".call" do
    let(:title) { "More trees" }
    let(:description) { "Plant trees in the main square" }
    let(:chat) { double }
    let(:response) do
      ProposalFeedback::Llm::Client.call(title: title,
                                         summary: "Greener city",
                                         description: description,
                                         tags: "Environment, Trees")
    end

    before do
      Setting["llm.provider"] = "OpenAI"
      Setting["llm.model"] = "gpt-4o"
      Setting["llm.use_ai_proposal_feedback"] = true
      Setting["llm.proposal_feedback_criteria"] = "Be specific"
      allow(Llm::Config).to receive(:chat).and_return(chat)
      allow(YAML).to receive(:load_file).and_return({
        "proposal_feedback_prompt" => "%{criteria} | %{title} | %{summary} | %{description} | " \
                                      "%{tags} | %{output_locale}"
      })
    end

    it "returns the LLM feedback for the criteria, the proposal fields and the current locale" do
      allow(chat).to receive(:ask)
                 .with("Be specific | More trees | Greener city | Plant trees in the main square | " \
                       "Environment, Trees | en")
                 .and_return(double(content: "Explain who would benefit."))

      expect(response.feedback).to eq "Explain who would benefit."
      expect(response.errors).to be_empty
    end

    context "when title and description are blank" do
      let(:title) { "" }
      let(:description) { "" }

      it "adds an error without calling the LLM" do
        expect(chat).not_to receive(:ask)

        expect(response.errors).to eq ["To get feedback, please write a title and description first."]
      end
    end

    context "when the feature is disabled" do
      before { Setting["llm.use_ai_proposal_feedback"] = false }

      it "adds an error without calling the LLM" do
        expect(chat).not_to receive(:ask)

        expect(response.errors).to eq ["LLM is not properly configured. Please contact an administrator."]
      end
    end

    context "when RubyLLM::Error is raised" do
      before { allow(chat).to receive(:ask).and_raise(RubyLLM::Error.new(nil, "LLM error")) }

      it "adds the error message to the response errors" do
        expect(response.errors).to eq ["LLM error"]
      end
    end
  end
end
