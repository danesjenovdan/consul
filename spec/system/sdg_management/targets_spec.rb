require "rails_helper"

describe "Targets" do
  before do
    login_as(create(:administrator).user)
    Setting["feature.sdg"] = true
  end

  describe "Index" do
=begin REWORK CHANGE
    scenario "Visit the index" do
      visit sdg_management_goals_path
      click_link "Targets"

      expect(page).to have_title "SDG content - Targets"
      within("table") { expect(page).to have_content "By 2030, eradicate extreme poverty" }
    end
=end
    scenario "Show targets grouped by goal and sorted asc by code" do
      goal_8 = SDG::Goal[8]
      goal_8_target_2 = SDG::Target["8.2"]
      goal_8_target_10 = SDG::Target["8.10"]
      goal_16 = SDG::Goal[16]
      goal_16_target_10 = SDG::Target["16.10"]
      goal_16_target_a = SDG::Target["16.A"]

      visit sdg_management_targets_path

      expect(goal_8.title).to appear_before(goal_8_target_2.title)
      expect(goal_8_target_2.title).to appear_before(goal_8_target_10.title)
      expect(goal_8_target_10.title).to appear_before(goal_16.title)
      expect(goal_16.title).to appear_before(goal_16_target_10.title)
      expect(goal_16_target_10.title).to appear_before(goal_16_target_a.title)
    end
  end
end
