module SpeechToText
  module Llm
    class Client
      def self.call(audio_file:, locale:)
        new(audio_file: audio_file, locale: locale).call
      end

      def initialize(audio_file:, locale:)
        @audio_file = audio_file
        @locale = locale
      end

      def call
        validate_llm_settings!
        transcribe_audio unless response.errors.any?
        response
      end

      def response
        @response ||= Response.new
      end

      class Response
        attr_accessor :text, :segments
        attr_reader :errors

        def initialize
          @text = ""
          @segments = []
          @errors = []
        end
      end

      private

        def locale_language
          @locale.to_s.split("-").first.presence
        end

        def transcribe_audio
          rewind_audio_file

          transcription = ::Llm::Config.transcribe(
            audio_file_for_transcription,
            model: Setting["llm.speech_to_text_model"],
            language: locale_language
          )

          response.text = transcription.text.to_s.strip
          response.segments = transcription.respond_to?(:segments) ? (transcription.segments || []) : []
        rescue RubyLLM::ConfigurationError
          response.errors << I18n.t("speech_to_text.errors.llm_not_configured")
        rescue RubyLLM::Error => e
          response.errors << e.message
        end

        def rewind_audio_file
          file = audio_file_for_transcription
          file.rewind if file.respond_to?(:rewind)
        end

        def audio_file_for_transcription
          if defined?(ActionDispatch::Http::UploadedFile) && @audio_file.is_a?(ActionDispatch::Http::UploadedFile)
            @audio_file.tempfile
          else
            @audio_file
          end
        end

        def validate_llm_settings!
          unless speech_to_text_configured?
            response.errors << I18n.t("speech_to_text.errors.llm_not_configured")
          end
        end

        def speech_to_text_configured?
          ::Llm::Config.configured? &&
            Setting["llm.use_llm_speech_to_text"].present? &&
            Setting["llm.speech_to_text_model"].present? &&
            ::Llm::Config.speech_to_text_model_available?
        end
    end
  end
end
