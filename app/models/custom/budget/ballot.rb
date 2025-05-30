load Rails.root.join('app', 'models', 'budget', 'ballot.rb')

class Budget
  class Ballot < ApplicationRecord

    # all headings are valid, so just check if it's the right budget
    def valid_heading?(heading)
      !wrong_budget?(heading)
    end

  end
end
