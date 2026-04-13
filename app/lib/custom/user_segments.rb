load Rails.root.join("app", "lib", "user_segments.rb")

class UserSegments
  def self.segments
    %w[all_users
       currently_active_budgets_proposal_authors
       currently_active_budgets_users_without_submissions
       currently_active_budgets_selected_proposal_authors
       currently_active_budgets_unfeasible_proposal_authors
       currently_active_budgets_undecided_feasibility_proposal_authors
       currently_active_budgets_winner_investment_authors
       currently_active_budgets_loser_investment_authors
       users_without_votes_in_currently_active_budgets
    ] + geozones.keys
  end

  def self.currently_active_budgets_proposal_authors
    open_budget_ids = Budget.published.open.pluck(:id)
    author_ids(Budget::Investment.where(budget_id: open_budget_ids).pluck(:author_id))
  end

  def self.currently_active_budgets_users_without_submissions
    User.where.not(id: currently_active_budgets_proposal_authors) # ali pa še .ids
  end

  def self.currently_active_budgets_selected_proposal_authors
    open_budget_ids = Budget.published.open.pluck(:id)
    author_ids(Budget::Investment.where(budget_id: open_budget_ids).selected.pluck(:author_id))
  end

  def self.currently_active_budgets_unfeasible_proposal_authors
    open_budget_ids = Budget.published.open.pluck(:id)
    author_ids(Budget::Investment.where(budget_id: open_budget_ids).unfeasible.pluck(:author_id))
  end

  def self.currently_active_budgets_undecided_feasibility_proposal_authors
    open_budget_ids = Budget.published.open.pluck(:id)
    author_ids(Budget::Investment.where(budget_id: open_budget_ids).undecided.pluck(:author_id))
  end

  def self.currently_active_budgets_winner_investment_authors
    open_budget_ids = Budget.published.open.pluck(:id)
    author_ids(Budget::Investment.where(budget_id: open_budget_ids).winners.pluck(:author_id))
  end

  def self.currently_active_budgets_loser_investment_authors
    open_budget_ids = Budget.published.open.pluck(:id)
    author_ids(Budget::Investment.where(budget_id: open_budget_ids).selected.compatible.where(winner: false).pluck(:author_id))
  end

  def self.users_without_votes_in_currently_active_budgets
    open_budget_ids = Budget.published.open.pluck(:id)
    User.where.not(id: Budget::Ballot.joins(:lines).where(budget_ballot_lines: {budget_id: [14]}).pluck(:user_id).uniq)
  end
end
