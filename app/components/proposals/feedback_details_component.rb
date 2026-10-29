class Proposals::FeedbackDetailsComponent < ApplicationComponent
  attr_reader :feedback
  delegate :markdown, to: :helpers

  def initialize(feedback)
    @feedback = feedback
  end
end
