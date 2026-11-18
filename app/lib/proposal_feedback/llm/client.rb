module ProposalFeedback
  module Llm
    class Client
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
        elsif @fields.values.none?(&:present?)
          response.errors << I18n.t("proposals.feedback.errors.blank_draft")
        else
          parse(::Llm::Config.chat.ask(prompt))
        end

        response
      rescue RubyLLM::Error, Faraday::Error, Timeout::Error
        response.errors << I18n.t("proposals.feedback.errors.request_failed")
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

        def parse(message)
          feedback = message.content.to_s.strip

          if feedback.present?
            response.feedback = feedback
          else
            response.errors << I18n.t("proposals.feedback.errors.invalid_response")
          end
        end

        def prompt
          ::Llm::Config.prompts["proposal_feedback_prompt"] % {
            criteria: Setting["llm.proposal_feedback_criteria"],
            proposal: proposal,
            output_locale: I18n.locale
          }
        end

        def proposal
          @fields.map { |name, value| %(<field name="#{name}">#{value}</field>) }.join("\n")
        end
    end
  end
end
