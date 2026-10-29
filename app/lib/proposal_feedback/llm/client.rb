module ProposalFeedback
  module Llm
    class Client
      MAX_SUMMARY_POINTS = 4
      SCHEMA = {
        type: "object",
        properties: {
          summary: { type: "array", items: { type: "string" }, minItems: 1, maxItems: MAX_SUMMARY_POINTS },
          feedback: { type: "string" }
        },
        required: ["summary", "feedback"],
        additionalProperties: false
      }.freeze

      def self.call(fields)
        new(fields).call
      end

      def self.enabled?
        ::Llm::Config.configured? && Setting["llm.use_ai_proposal_feedback"].present?
      end

      def initialize(fields)
        @fields = fields
      end

      def call
        if !self.class.enabled?
          response.errors << I18n.t("proposals.feedback.errors.llm_not_configured")
        elsif @fields.values.any?(&:present?)
          parse(::Llm::Config.chat.with_schema(SCHEMA).ask(prompt))
        end

        response
      rescue RubyLLM::Error => e
        response.errors << e.message
        response
      end

      class Response
        attr_accessor :summary, :feedback
        attr_reader :errors

        def initialize
          @summary = []
          @errors = []
        end
      end

      private

        def response
          @response ||= Response.new
        end

        def parse(message)
          content = message.parsed
          raise JSON::ParserError unless content.is_a?(Hash)

          response.summary = Array(content["summary"]).first(MAX_SUMMARY_POINTS)
          response.feedback = content["feedback"]
        rescue JSON::ParserError
          response.errors << I18n.t("proposals.feedback.errors.invalid_response")
        end

        def prompt
          ::Llm::Config.prompts["proposal_feedback_prompt"] % {
            criteria: Setting["llm.proposal_feedback_criteria"],
            proposal: proposal,
            max_summary_points: MAX_SUMMARY_POINTS,
            output_locale: I18n.locale
          }
        end

        def proposal
          @fields.map { |name, value| %(<field name="#{name}">#{value}</field>) }.join("\n")
        end
    end
  end
end
