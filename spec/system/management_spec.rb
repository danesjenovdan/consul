require "rails_helper"
=begin REWORK CHANGE
describe "Management" do
  let(:user) { create(:user) }
  before { Setting["org_name"] = "CONSUL" }

  scenario "Should show admin menu if logged user is admin" do
    create(:administrator, user: user)
    login_as(user)

    visit root_path
    click_link "Menu" REWORK CHANGE
    click_link "Management" REWORK CHANGE

    expect(page).to have_link "Go back to CONSUL"

    expect(page).to have_link "You don't have new notifications"
    expect(page).to have_link "My content"
    expect(page).to have_link "My account"
    expect(page).to have_link "Sign out"
  end

  scenario "Should not show admin menu if logged user is manager" do
    create(:manager, user: user)
    login_as(user)
    visit root_path

    click_link "Menu" REWORK CHANGE
    click_link "Management" REWORK CHANGE

    expect(page).to have_link "Go back to CONSUL"

    expect(page).not_to have_content "You don't have new notifications"
    expect(page).not_to have_content "My content"
    expect(page).not_to have_content "My account"
    expect(page).not_to have_content "Sign out"
  end
end
=end
