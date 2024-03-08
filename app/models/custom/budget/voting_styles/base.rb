require_dependency Rails.root.join('app', 'models', 'budget', 'voting_styles', 'base').to_s

class Budget::VotingStyles::Base
  def total_amount_spent
    total = 0
    Budget::Ballot::Line.where(ballot_id: @ballot.id).each do |line|
      total += line.investment.price
    end
    total
  end

  def amount_available(heading)
    amount_limit(heading) - total_amount_spent
  end

  def percentage_spent(heading)
    100.0 * total_amount_spent / amount_limit(heading)
  end

  def formatted_amount_spent(heading)
    format(total_amount_spent)
  end
end