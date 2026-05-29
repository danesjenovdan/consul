class Admin::Settings::LlmConfigurationTabComponent < ApplicationComponent
  SPEECH_TO_TEXT_MODELS = {
    "OpenAI" => %w[whisper-1 gpt-4o-transcribe gpt-4o-mini-transcribe gpt-4o-transcribe-diarize],
    "Gemini" => %w[gemini-2.5-flash gemini-2.5-pro]
  }.freeze

  def tab
    "#tab-llm-configuration"
  end

  def providers
    Llm::Config.providers
  end

  def provider_options
    current = Setting["llm.provider"]
    options_values = providers.keys.map { |key| [key.to_s, key.to_s] }
    disabled_values = providers.reject { |_key, value| value[:enabled] }.keys

    options_for_select(options_values, selected: current, disabled: disabled_values)
  end

  def models
    provider = Setting["llm.provider"]
    return {} if provider.blank?

    RubyLLM.models.by_provider(provider.downcase.to_sym).to_h do |model|
      [model.name, { id: model.id }]
    end
  end

  def model_options
    current = Setting["llm.model"]
    options_values = models.map { |name, value| [name, value[:id]] }

    options_for_select(options_values, selected: current)
  end

  def model_disabled?
    Setting["llm.provider"].blank?
  end

  def feature_disabled?
    !::Llm::Config.configured?
  end

  def image_suggestions_disabled?
    !::Llm::Config.configured? || Tenant.current_secrets.pexels_access_key.blank?
  end

  def speech_to_text_model_options
    current = Setting["llm.speech_to_text_model"]

    safe_join(SPEECH_TO_TEXT_MODELS.map do |provider_name, models|
      disabled = provider_enabled?(provider_name) ? [] : models
      content_tag(:optgroup, label: provider_name) do
        options_for_select(models, selected: current, disabled: disabled)
      end
    end)
  end

  def speech_to_text_disabled?
    !::Llm::Config.configured? || stt_providers_unavailable?
  end

  def speech_to_text_model_disabled?
    speech_to_text_disabled? || Setting["llm.use_llm_speech_to_text"].blank?
  end

  private

    def stt_providers_unavailable?
      SPEECH_TO_TEXT_MODELS.keys.none? { |provider_name| provider_enabled?(provider_name) }
    end

    def provider_enabled?(provider_name)
      providers.find { |key, _value| key.to_s.casecmp(provider_name).zero? }&.last&.dig(:enabled)
    end
end
