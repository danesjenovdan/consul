module ImageSuggestions
  module Llm
    class Client
      NUMBER_OF_IMAGES = 4
      # these could potentially become user configurable, but we don't want to pollute
      # the settings too much - this should be plenty liberal.
      RATE_LIMIT_REQUESTS = 10
      RATE_LIMIT_WINDOW = 15.minutes

      attr_reader :chat, :prompt, :response, :rate_limit_cache_key

      def self.call(title:, description:, rate_limit_cache_key:)
        new(title: title, description: description, rate_limit_cache_key: rate_limit_cache_key).call
      end

      def initialize(title:, description:, rate_limit_cache_key:)
        @title = title
        @description = description
        @rate_limit_cache_key = rate_limit_cache_key
        @prompt = load_prompt
        @response = Response.new
        @chat = build_chat
      end

      def call
        if rate_limited?
          response.errors << I18n.t("images.errors.messages.rate_limit_exceeded")
          return response
        end

        increment_rate_limit_counter

        validate_llm_settings!
        return response if response.errors.any?

        search_query = generate_search_query
        return response if response.errors.any?

        results = ImageSuggestions::Pexels.search(search_query, per_page: NUMBER_OF_IMAGES)
        response.results = results
      rescue ::Pexels::APIError, RubyLLM::Error => e
        response.errors << e.message
      ensure
        return response
      end

      class Response
        attr_accessor :results
        attr_reader :errors

        def initialize
          @results = []
          @errors = []
        end
      end

      private

        def rate_limited?
          return false unless rate_limit_cache_key

          count = Rails.cache.read(rate_limit_cache_key).to_i
          count >= RATE_LIMIT_REQUESTS
        end

        def increment_rate_limit_counter
          return unless rate_limit_cache_key

          count = Rails.cache.read(rate_limit_cache_key).to_i
          Rails.cache.write(rate_limit_cache_key, count + 1, expires_in: RATE_LIMIT_WINDOW)
        end

        def build_chat
          ::Llm::Config.context.chat(provider: llm_provider, model: llm_model)
        end

        def generate_search_query
          if @title.blank? && @description.blank?
            response.errors << I18n.t("images.errors.messages.title_and_description_required")
            return
          end

          text_prompt = prompt % { title: @title, description: @description }
          chat.ask(text_prompt).content.strip
        end

        def load_prompt
          YAML.load_file("config/llm_prompts.yml", aliases: true)["image_suggestion_prompt"]
        end

        def validate_llm_settings!
          if llm_provider.blank? || llm_model.blank? || !Setting["llm.use_ai_image_suggestions"]
            response.errors << I18n.t("images.errors.messages.llm_not_configured")
          end
        end

        def llm_provider
          Setting["llm.provider"]&.downcase&.to_sym
        end

        def llm_model
          Setting["llm.model"]
        end
    end
  end
end
