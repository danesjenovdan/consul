load Rails.root.join('app', 'models', 'budget', 'phase.rb')

class Budget
  class Phase < ApplicationRecord

    # translates :summary, touch: true
    # translates :description, touch: true
    translates :presentation_summary_accepting, touch: true
    translates :presentation_summary_balloting, touch: true
    translates :presentation_summary_finished, touch: true
    include Globalizable

  end
end
