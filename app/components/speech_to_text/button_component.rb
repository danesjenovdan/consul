class SpeechToText::ButtonComponent < ApplicationComponent
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def render?
    ::Llm::Config.configured? &&
      Setting["llm.use_llm_speech_to_text"].present? &&
      Setting["llm.speech_to_text_model"].present?
  end

  private

    def textarea_id
      "#{form.object_name}[description]".gsub(/[\]\[]+/, "_").delete_suffix("_")
    end

    def locale
      form.respond_to?(:locale) ? form.locale : I18n.locale
    end
end
