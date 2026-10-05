module ProposalFeedback
  module Llm
    class Client
      def self.call(...)
        new(...).call
      end

      def self.enabled?
        ::Llm::Config.configured? && Setting["llm.use_ai_proposal_feedback"].present?
      end

      def initialize(title:, summary:, description:, tags:)
        @title = title
        @summary = summary
        @description = description
        @tags = tags
      end

      def call
        if !self.class.enabled?
          response.errors << I18n.t("proposals.feedback.errors.llm_not_configured")
        elsif @title.blank? && @description.blank?
          response.errors << I18n.t("proposals.feedback.errors.title_and_description_required")
        else
          response.feedback = ::Llm::Config.chat.ask(prompt).content
        end

        response
      rescue RubyLLM::Error => e
        response.errors << e.message
        response
      end

      class Response
        attr_accessor :feedback
        attr_reader :errors

        def initialize
          @errors = []
        end
      end

      private

        def response
          @response ||= Response.new
        end

        def prompt
          ::Llm::Config.prompts["proposal_feedback_prompt"] % {
            criteria: Setting["llm.proposal_feedback_criteria"],
            title: @title,
            summary: @summary,
            description: @description,
            tags: @tags,
            output_locale: I18n.locale
          }
        end
    end
  end
end
