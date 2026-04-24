class Admin::BudgetPhases::DjndFormComponent < ApplicationComponent
  include TranslatableFormHelper
  include GlobalizeHelper
  include Admin::Namespace

  delegate :cktext_area, to: :helpers

  attr_reader :phase

  def initialize(phase)
    @phase = phase
  end

end
