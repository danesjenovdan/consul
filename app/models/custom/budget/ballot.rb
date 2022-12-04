require_dependency Rails.root.join('app', 'models', 'budget', 'ballot').to_s

class Budget
  class Ballot < ApplicationRecord
    def valid_heading?(heading)
      heading.id == user.heading_id
    end
  end
end
