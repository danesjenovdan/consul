require_dependency Rails.root.join('app', 'models', 'budget', 'voting_styles', 'knapsack').to_s

class Budget::VotingStyles::Knapsack < Budget::VotingStyles::Base
    def amount_limit(heading)
      30000
    end
  end
  