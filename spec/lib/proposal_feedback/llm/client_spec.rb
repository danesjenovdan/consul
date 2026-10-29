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
      allow(chat).to receive(:with_schema).with(ProposalFeedback::Llm::Client::SCHEMA).and_return(chat)
      allow(YAML).to receive(:load_file).and_return({
        "proposal_feedback_prompt" => "%{criteria} | %{proposal} | %{max_summary_points} | %{output_locale}"
      })
    end

    it "returns the summary and the feedback for the criteria, the fields and the current locale" do
      allow(chat).to receive(:ask)
                 .with("Be specific | <field name=\"title\">More trees</field>\n" \
                       "<field name=\"description\">Plant trees in the main square</field> | 4 | en")
                 .and_return(reply({ summary: ["Explain who would benefit."],
                                     feedback: "**Who** would benefit?" }.to_json))

      expect(response.summary).to eq ["Explain who would benefit."]
      expect(response.feedback).to eq "**Who** would benefit?"
      expect(response.errors).to be_empty
    end

    it "returns at most four summary points" do
      allow(chat).to receive(:ask)
                 .and_return(reply({ summary: %w[One Two Three Four Five], feedback: "" }.to_json))

      expect(response.summary).to eq %w[One Two Three Four]
    end

    ["Explain who would benefit.", "", "[]"].each do |content|
      it "adds an error when the LLM replies with #{content.inspect} instead of a JSON object" do
        allow(chat).to receive(:ask).and_return(reply(content))

        expect(response.feedback).to be nil
        expect(response.errors).to eq ["The feedback could not be generated. Please try again."]
      end
    end

    context "when all fields are blank" do
      let(:fields) { { title: "", description: nil } }

      it "returns no feedback and no errors without calling the LLM" do
        expect(chat).not_to receive(:ask)

        expect(response.feedback).to be nil
        expect(response.errors).to be_empty
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
      before { allow(chat).to receive(:ask).and_raise(RubyLLM::Error.new("LLM error")) }

      it "adds the error message to the response errors" do
        expect(response.errors).to eq ["LLM error"]
      end
    end
  end
end
