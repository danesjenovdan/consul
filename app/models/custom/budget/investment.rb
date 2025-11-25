load Rails.root.join('app', 'models', 'budget', 'investment.rb')

class Budget
  class Investment < ApplicationRecord

    has_many :answers, class_name: "Investment::Answer"
    accepts_nested_attributes_for :answers

    validates_translation :description, presence: false, length: { maximum: Budget::Investment.description_max_length }

    validate :all_answers

    def all_answers
      errors.add(:answers, I18n.t('activerecord.errors.models.user.attributes.document_number.invalid')) unless has_all_answers?
    end

    def has_all_answers?
      filtered_answers = answers.select { |answer| !answer.text.nil? && answer.text.strip != "" }
      empty_answers = answers.select { |answer| answer.text.nil? || answer.text.strip == "" }
      if (filtered_answers.length == self.budget.questions.count)
        return true
      end
      if ((
        filtered_answers.length == self.budget.questions.count - 1
      ) && (
        empty_answers.length == 1
      ) && (
        Budget::Question.where(id: empty_answers[0].budget_question_id).first.text == "A3"
      ))
        empty_answers[0].text = 'NI IZPOLNJENO' # TODO warning this is a bit dodgy because it has side effects, but it works (for now)
        return true
      end
    end

    # this is quite possibly useless and/or redundant
    def self.description
      unless self.budget.questions.any? do
        self.description
      end

      return 'OPIS MANJKA UPS'
    end

  end
end
end