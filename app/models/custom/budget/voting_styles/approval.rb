load Rails.root.join('app', 'models', 'budget', 'voting_styles', 'approval.rb')

class Budget::VotingStyles::Approval < Budget::VotingStyles::Base

  # limit the amount of votes to 3
  def amount_limit(heading)
    3
  end

  private

    # ignores the heading and returns all the investments on the ballot
    # this is originally defined in base
    def investments(heading)
      ballot.investments
    end

end
