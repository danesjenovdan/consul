module ImageSuggestions
  module Llm
    class Client
      class Response
        attr_accessor :results
        attr_reader :errors

        def initialize
          @results = []
          @errors = []
        end
      end

      NUMBER_OF_IMAGES = 4
      attr_reader :model_instance, :chat, :prompt, :response

      def self.call(model_instance)
        new(model_instance).call
      end

      def initialize(model_instance)
        @model_instance = model_instance
        @chat = build_chat
        @prompt = load_prompt
        @response = Response.new
      end

      def call
        begin
          search_query = generate_search_query
          return response if response.errors.any?

          results = ImageSuggestions::Pexels.search(search_query, size: :small,
                                                                  per_page: NUMBER_OF_IMAGES)
          response.results = results
        rescue ImageSuggestions::Pexels::PexelsError, ::Pexels::APIError, RubyLLM::Error => e
          response.errors << e.message
        end
        response
      end

      private

        def build_chat
          context = build_context
          context.chat(provider: llm_provider, model: llm_model)
        end

        def build_context
          ::Llm::Config.context
        end

        def load_prompt
          YAML.load_file("config/llm_prompts.yml", aliases: true)["image_suggestion_prompt"]
        end

        def generate_search_query
          if title_text.blank? && description_text.blank?
            response.errors << I18n.t("images.errors.messages.title_and_description_required")
            return response
          end

          text_prompt = prompt % { title: title_text, description: description_text }
          response.results = chat.ask(text_prompt).content.strip
        end

        def title_text
          model_instance.respond_to?(:title) ? model_instance.title.to_s : ""
        end

        def description_text
          model_instance.respond_to?(:description) ? model_instance.description.to_s : ""
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
