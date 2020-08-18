require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s

class Budget
  class Investment < ApplicationRecord

    # TODO this was commented out because aparently you can now set this in settings
    # change some defaults
    # documentable max_documents_allowed: 5,
    #              max_file_size: 3.megabytes,
    #              accepted_content_types: [ "application/pdf", "image/gif", "image/jpeg", "image/png", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/vnd.ms-powerpoint", "application/vnd.openxmlformats-officedocument.presentationml.presentation" ]

    # remove existing validator
    self.class_eval do
      _validators[:title]
        .find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }
        .attributes
        .delete(:title)
    end

    def should_show_ballots?
      (budget.balloting? && selected?) || (budget.reviewing_ballots?)
    end

    def should_show_vote_count?
      budget.finished?
    end

    def description
      compiled_description = q1.to_s + q2.to_s + q3.to_s + q4.to_s + q5.to_s + q6.to_s + q7.to_s
      read_attribute(:description) != '' ? compiled_description : read_attribute(:description) 
    end

  end
end
