require_dependency Rails.root.join('app', 'models', 'budget', 'voting_styles', 'knapsack').to_s

class Budget::VotingStyles::Knapsack < Budget::VotingStyles::Base
    def amount_available(heading)
      amount_limit(heading) - all_investments_price
    end
  
    def enough_resources?(investment)
      investment.price.to_i <= amount_available(investment.heading)
    end
  
    def reason_for_not_being_ballotable(investment)
      :not_enough_money unless enough_resources?(investment)
    end
  
    def not_enough_resources_error
      "insufficient funds"
    end
  
    def amount_spent(heading)
      all_investments_price
    end
  
    def amount_limit(heading)
      # ballot.budget.heading_price(heading)
      50000
    end
  
    def format(amount)
      ballot.budget.formatted_amount(amount)
    end
  
    private
      def all_investments
        ballot.investments
      end
  
      def all_investments_price
          all_investments.sum(:price).to_i
      end
  end
  