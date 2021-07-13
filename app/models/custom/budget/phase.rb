require_dependency Rails.root.join("app", "models", "budget", "phase").to_s

class Budget
  class Phase < ApplicationRecord
    SUMMARY_MAX_LENGTH = 100
    include Globalizable

    validates :presentation_summary_1, length: { maximum: SUMMARY_MAX_LENGTH }
    validates :presentation_summary_2, length: { maximum: SUMMARY_MAX_LENGTH }
    validates :presentation_summary_3, length: { maximum: SUMMARY_MAX_LENGTH }

    def enabled
      enabled?
    end
  end
end
