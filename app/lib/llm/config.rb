module Llm
  class Config
    class << self
      def context
        @context = RubyLLM.context do |config|
          ENV["GOOGLE_APPLICATION_CREDENTIALS"] ||= Rails.application.secrets.google_application_credentials

          Tenant.current_secrets.llm&.each do |key, value|
            config.send("#{key}=", value)
          end
        end
      end

      def providers
        RubyLLM::Providers.constants.to_h do |provider|
          [provider, { enabled: RubyLLM::Providers.const_get(provider).configured?(context.config) }]
        end
      end

      def prompts
        YAML.load_file("config/llm_prompts.yml", aliases: true)
      end

      def chat(provider: llm_provider, model: llm_model)
        context.chat(provider: provider, model: model)
      end

      def transcribe(audio_file, model:, language: nil)
        RubyLLM.transcribe(audio_file, model: model, language: language, context: context)
      end

      def configured?
        llm_provider.present? && llm_model.present?
      end

      def speech_to_text_model_available?(model = Setting["llm.speech_to_text_model"])
        return false if model.blank?

        model_info = RubyLLM::Models.find(model)
        provider_key = providers.keys.find { |key| key.to_s.casecmp(model_info.provider).zero? }
        providers.fetch(provider_key, { enabled: false })[:enabled]
      rescue RubyLLM::ModelNotFoundError
        false
      end

      private

        def llm_provider
          Setting["llm.provider"]&.downcase&.to_sym
        end

        def llm_model
          Setting["llm.model"]
        end
    end
  end
end
