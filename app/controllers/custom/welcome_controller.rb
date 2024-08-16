load Rails.root.join("app", "controllers", "welcome_controller.rb")

class WelcomeController < ApplicationController
  skip_authorization_check

  before_action :load_budgets, :load_past_budgets, only: [:index]

  layout "devise", only: [:verification]

  def load_budgets
    @budgets = Budget.where("id > -1");
  end

  def load_past_budgets 
    @past_budgets = Budget.finished
  end
end
