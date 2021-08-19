require_dependency Rails.root.join("app", "models", "budget").to_s

class Budget < ApplicationRecord
  CUSTOM_PHASE_ACCEPTING = :accepting
  CUSTOM_PHASE_SELECTING = :selecting
  CUSTOM_PHASE_BALLOTING = :balloting
  CUSTOM_PHASE_FINISHED = :finished

  CustomPhase = Struct.new(:kind, :summary, :presentation_summary_1,
    :presentation_summary_2, :presentation_summary_3, :description,
    :starts_at, :ends_at, :url, :enabled) do
  end

  def self.current
    where.not(phase: :drafting).order(:created_at).last
  end

  def custom_phases(current_user, budget_investments_url)
    custom_phases = {}
    {
      CUSTOM_PHASE_ACCEPTING => true,
      CUSTOM_PHASE_SELECTING => self.phases.selecting.enabled?,
      CUSTOM_PHASE_BALLOTING => true,
      CUSTOM_PHASE_FINISHED => true
    }.each do |phase, enabled|
      url = nil
      if self.phase === phase.to_s
        if self.phase === "balloting"
          url = budget_investments_url.call(
            self,
            heading_id: current_user&.balloted_heading_id ?
              current_user&.balloted_heading_id :
              self&.headings&.first&.id
          )
        else
          url = budget_investments_url.call(self)
        end
      end
      custom_phases[phase] = CustomPhase.new(
        phase,
        current_phase&.summary,
        current_phase&.presentation_summary_1,
        current_phase&.presentation_summary_2,
        current_phase&.presentation_summary_3,
        current_phase&.description,
        current_phase&.starts_at,
        current_phase&.ends_at,
        url,
        enabled
      )
    end
    custom_phases = custom_phases_links(custom_phases, budget_investments_url)
  end

  def custom_phases_links(custom_phases, budget_investments_url)
    current_phase = self.phase
    if ["accepting", "reviewing"].include? current_phase
      custom_phases[CUSTOM_PHASE_ACCEPTING].url = budget_investments_url.call(self)
    elsif ["selecting", "valuating", "publishing_prices"].include? current_phase
      if custom_phases[CUSTOM_PHASE_SELECTING].enabled
        custom_phases[CUSTOM_PHASE_SELECTING].url = budget_investments_url.call(self)
      else
        custom_phases[CUSTOM_PHASE_ACCEPTING].url = budget_investments_url.call(self)
      end
    elsif current_phase === "balloting"
      custom_phases[CUSTOM_PHASE_BALLOTING].url = budget_investments_url
      .call(self, heading_id: self.headings.first.id)
    elsif current_phase === "reviewing_ballots"
      custom_phases[CUSTOM_PHASE_BALLOTING].url = budget_investments_url.call(self)
    elsif current_phase === "finished"
      custom_phases[CUSTOM_PHASE_FINISHED].url = budget_investments_url.call(self)
    end
    custom_phases
  end
end
