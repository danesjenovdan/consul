require "rails_helper"

describe SpeechToText::ButtonComponent do
  let(:budget_investment) { build(:budget_investment) }
  let(:form) do
    ConsulFormBuilder.new(:budget_investment, budget_investment, ApplicationController.new.view_context, {})
  end
  let(:component) { SpeechToText::ButtonComponent.new(form) }

  before do
    Setting["llm.provider"] = nil
    Setting["llm.model"] = nil
    Setting["llm.use_llm_speech_to_text"] = nil
    Setting["llm.speech_to_text_model"] = nil
  end

  context "when all required settings are present" do
    before do
      Setting["llm.provider"] = "OpenAI"
      Setting["llm.model"] = "gpt-4o"
      Setting["llm.use_llm_speech_to_text"] = true
      Setting["llm.speech_to_text_model"] = "whisper-1"
    end

    it "renders the speech to text button" do
      render_inline component

      expect(page).to be_rendered
      expect(page).to have_css(".speech-to-text-wrapper")
      expect(page).to have_css("button.js-speech-to-text", text: "Say it instead")
    end
  end

  context "when provider/model are not configured" do
    it "does not render the component" do
      render_inline component

      expect(page).not_to be_rendered
    end
  end

  context "when speech-to-text switch is disabled" do
    before do
      Setting["llm.provider"] = "OpenAI"
      Setting["llm.model"] = "gpt-4o"
      Setting["llm.use_llm_speech_to_text"] = nil
      Setting["llm.speech_to_text_model"] = "whisper-1"
    end

    it "does not render the component" do
      render_inline component

      expect(page).not_to be_rendered
    end
  end

  context "when speech-to-text model is missing" do
    before do
      Setting["llm.provider"] = "OpenAI"
      Setting["llm.model"] = "gpt-4o"
      Setting["llm.use_llm_speech_to_text"] = true
      Setting["llm.speech_to_text_model"] = nil
    end

    it "does not render the component" do
      render_inline component

      expect(page).not_to be_rendered
    end
  end
end
