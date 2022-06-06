require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s

class Budget
  class Investment < ApplicationRecord

    has_many :answers, class_name: "Investment::Answer"
    accepts_nested_attributes_for :answers

    validates_translation :description, presence: false, length: { maximum: Budget::Investment.description_max_length }

    validate :medvode_answers

    def all_answers
      errors.add(:answers, I18n.t('activerecord.errors.models.user.attributes.document_number.invalid')) unless has_all_answers?
    end

    def has_all_answers?
      filtered_answers = answers.select { |answer| answer.text.strip != "" }
      filtered_answers.length == self.budget.questions.count
    end

    def medvode_answers
      errors.add(:answers, I18n.t('activerecord.errors.models.user.attributes.document_number.invalid')) unless has_medvode_answers?
    end

    def has_medvode_answers?
      filtered_answers = answers.select { |answer| answer.text.strip != "" }
      all_answers = filtered_answers.length == self.budget.questions.count
      enough_answers = filtered_answers.length == self.budget.questions.count - 1
      correct_answer_missing = answers[5].text.strip == ''
      all_answers || (enough_answers && correct_answer_missing)
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