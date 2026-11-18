require "rails_helper"

describe ProposalFeedback::Llm::Client do
  describe ".call" do
    let(:fields) { { title: "More trees", description: "Plant trees in the main square" } }
    let(:chat) { double }
    let(:response) { ProposalFeedback::Llm::Client.call(fields) }

    def reply(content)
      RubyLLM::Message.new(role: :assistant, content: content)
    end

    before do
      Setting["llm.provider"] = "OpenAI"
      Setting["llm.model"] = "gpt-4o"
      Setting["llm.use_ai_proposal_feedback"] = true
      Setting["llm.proposal_feedback_criteria"] = "Be specific"
      allow(Llm::Config).to receive(:chat).and_return(chat)
      allow(YAML).to receive(:load_file).and_return({
        "proposal_feedback_prompt" => "%{criteria} | %{proposal} | %{output_locale}"
      })
    end

    it "returns the feedback for the criteria, the fields and the current locale" do
      allow(chat).to receive(:ask)
                 .with("Be specific | <field name=\"title\">More trees</field>\n" \
                       "<field name=\"description\">Plant trees in the main square</field> | en")
                 .and_return(reply("- **Be specific: Not met.** Say where.\n"))

      expect(response.feedback).to eq "- **Be specific: Not met.** Say where."
      expect(response.errors).to be_empty
    end

    ["", "  \n"].each do |content|
      it "adds an error when the LLM replies with #{content.inspect}" do
        allow(chat).to receive(:ask).and_return(reply(content))

        expect(response.feedback).to be nil
        expect(response.errors).to eq ["The feedback could not be generated. Please try again."]
      end
    end

    context "when all fields are blank" do
      let(:fields) { { title: "", description: nil } }

      it "asks for the draft without calling the LLM" do
        expect(chat).not_to receive(:ask)

        expect(response.feedback).to be nil
        expect(response.errors).to eq ["Fill in the title, summary or text to get feedback."]
      end
    end

    context "when the feature is disabled" do
      before { Setting["llm.use_ai_proposal_feedback"] = false }

      it "adds an error without calling the LLM" do
        expect(chat).not_to receive(:ask)

        expect(response.errors).to eq ["LLM is not properly configured. Please contact an administrator."]
      end
    end

    [RubyLLM::Error.new("LLM error"), Faraday::TimeoutError.new("timeout")].each do |error|
      context "when #{error.class} is raised" do
        before { allow(chat).to receive(:ask).and_raise(error) }

        it "adds a friendly error message" do
          expect(response.errors).to eq ["Sorry, the feedback could not be generated right now. " \
                                         "Please try again later."]
        end
      end
    end
  end
end
