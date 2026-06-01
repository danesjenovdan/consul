require "rails_helper"

describe SpeechToText::Llm::Client do
  let(:audio_file) { StringIO.new("audio-bytes") }
  let(:transcription) { double(text: " dictated text ", segments: [{ "text" => "dictated text" }]) }

  before do
    stub_secrets(llm: { openai_api_key: "1234" })
    Setting["llm.provider"] = "OpenAI"
    Setting["llm.model"] = "gpt-4o"
    Setting["llm.use_llm_speech_to_text"] = true
    Setting["llm.speech_to_text_model"] = "whisper-1"
    allow(Llm::Config).to receive(:transcribe).and_return(transcription)
  end

  describe ".call" do
    it "creates a new instance and calls it with arguments" do
      expect(SpeechToText::Llm::Client).to receive(:new).with(audio_file: audio_file,
                                                              locale: "en").and_call_original

      SpeechToText::Llm::Client.call(audio_file: audio_file, locale: "en")
    end
  end

  describe "#call" do
    subject(:response) { SpeechToText::Llm::Client.new(audio_file: audio_file, locale: locale).call }

    let(:locale) { "en" }

    it "calls Llm::Config.transcribe with selected model and locale language" do
      response

      expect(Llm::Config).to have_received(:transcribe).with(audio_file, model: "whisper-1", language: "en")
    end

    it "returns stripped text and segments" do
      expect(response.text).to eq("dictated text")
      expect(response.segments).to eq([{ "text" => "dictated text" }])
      expect(response.errors).to be_empty
    end

    context "when locale includes region" do
      let(:locale) { "sv-SE" }

      it "uses only the language part" do
        response

        expect(Llm::Config).to have_received(:transcribe).with(audio_file, model: "whisper-1", language: "sv")
      end
    end

    context "when llm is not configured" do
      before { Setting["llm.provider"] = nil }

      it "returns configuration error and does not call transcribe" do
        expect(response.errors).to include("Speech to text is not configured. Please contact an administrator.")
        expect(Llm::Config).not_to have_received(:transcribe)
      end
    end

    context "when speech-to-text setting is disabled" do
      before { Setting["llm.use_llm_speech_to_text"] = nil }

      it "returns configuration error and does not call transcribe" do
        expect(response.errors).to include("Speech to text is not configured. Please contact an administrator.")
        expect(Llm::Config).not_to have_received(:transcribe)
      end
    end

    context "when speech-to-text model is missing" do
      before { Setting["llm.speech_to_text_model"] = nil }

      it "returns configuration error and does not call transcribe" do
        expect(response.errors).to include("Speech to text is not configured. Please contact an administrator.")
        expect(Llm::Config).not_to have_received(:transcribe)
      end
    end

    context "when speech-to-text model provider is not configured" do
      before do
        stub_secrets(llm: { gemini_api_key: "1234" })
        Setting["llm.speech_to_text_model"] = "whisper-1"
      end

      it "returns configuration error and does not call transcribe" do
        expect(response.errors).to include("Speech to text is not configured. Please contact an administrator.")
        expect(Llm::Config).not_to have_received(:transcribe)
      end
    end

    context "when transcription raises a configuration error" do
      before do
        allow(Llm::Config).to receive(:transcribe).and_raise(
          RubyLLM::ConfigurationError, "Missing configuration for OpenAI: openai_api_key"
        )
      end

      it "returns configuration error instead of empty text" do
        expect(response.text).to eq("")
        expect(response.errors).to include("Speech to text is not configured. Please contact an administrator.")
      end
    end
  end
end
