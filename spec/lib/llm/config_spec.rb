require "rails_helper"

describe Llm::Config do
  describe ".context" do
    let(:config) { double }
    let(:context_double) { double(config: config) }

    before do
      stub_secrets(llm: { openai_api_key: "1234" })
      allow(config).to receive(:openai_api_key=)
      expect(RubyLLM).to receive(:context).and_yield(config).and_return(context_double)
    end

    it "creates a context with tenant secrets without errors" do
      expect(config).to receive(:openai_api_key=).with("1234")

      expect { Llm::Config.context }.not_to raise_error
    end

    context "google_application_credentials is present" do
      before do
        stub_secrets(
          llm: { openai_api_key: "1234" },
          google_application_credentials: "/tmp/dummy.json"
        )
      end

      let!(:original_google_application_credentials) { ENV["GOOGLE_APPLICATION_CREDENTIALS"] }
      after { ENV["GOOGLE_APPLICATION_CREDENTIALS"] = original_google_application_credentials }

      it "sets GOOGLE_APPLICATION_CREDENTIALS" do
        Llm::Config.context

        expect(ENV["GOOGLE_APPLICATION_CREDENTIALS"]).to eq("/tmp/dummy.json")
      end
    end
  end

  describe ".providers" do
    it "maps provider enabled status using configured providers" do
      stub_secrets(llm: { openai_api_key: "1234" })

      providers = Llm::Config.providers

      expect(providers[:OpenAI]).to eq({ enabled: true })
      expect(providers[:DeepSeek]).to eq({ enabled: false })
    end

    it "discards providers with a blank configuration" do
      stub_secrets(llm: { openai_api_key: "" })

      expect(Llm::Config.providers[:OpenAI]).to eq({ enabled: false })
    end

    it "does not enable any providers when the LLM configuration is nil" do
      stub_secrets({})

      expect(Llm::Config.providers.values).to all eq({ enabled: false })
    end
  end

  describe ".speech_to_text_model_available?" do
    it "returns true when the model provider is configured" do
      stub_secrets(llm: { openai_api_key: "1234" })

      expect(Llm::Config.speech_to_text_model_available?("whisper-1")).to be true
    end

    it "returns false when the model provider is not configured" do
      stub_secrets(llm: { gemini_api_key: "1234" })

      expect(Llm::Config.speech_to_text_model_available?("whisper-1")).to be false
    end

    it "returns false for unknown models" do
      expect(Llm::Config.speech_to_text_model_available?("unknown-model")).to be false
    end
  end

  describe ".transcribe" do
    let(:context) { double("RubyLLM::Context") }

    before do
      allow(Llm::Config).to receive(:context).and_return(context)
    end

    it "delegates transcription to RubyLLM with context" do
      expect(RubyLLM).to receive(:transcribe).with("audio.wav", model: "whisper-1", language: "en",
                                                                context: context)

      Llm::Config.transcribe("audio.wav", model: "whisper-1", language: "en")
    end
  end

  describe "evaluates provider configuration across different tenants" do
    before do
      stub_secrets(
        llm: {
          openai_api_key: "1234"
        },
        tenants: {
          new_tenant_name: {
            llm: {
              deepseek_api_key: "1234",
              openrouter_api_key: "1234"
            }
          }
        }
      )
    end

    it "enables OpenAI for the default tenant" do
      allow(Tenant).to receive(:current_schema).and_return("public")

      providers = Llm::Config.providers

      expect(providers[:DeepSeek]).to include(enabled: false)
      expect(providers[:OpenRouter]).to include(enabled: false)
      expect(providers[:OpenAI]).to include(enabled: true)
    end

    it "enables DeepSeek and OpenRouter for the new_tenant_name tenant" do
      allow(Tenant).to receive(:current_schema).and_return("new_tenant_name")

      providers = Llm::Config.providers

      expect(providers[:DeepSeek]).to include(enabled: true)
      expect(providers[:OpenRouter]).to include(enabled: true)
      expect(providers[:OpenAI]).to include(enabled: false)
    end
  end
end
