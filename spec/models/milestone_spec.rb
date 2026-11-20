require "rails_helper"

describe Milestone do
  it_behaves_like "globalizable", :milestone
  it_behaves_like "globalizable", :milestone_with_description

  describe "Validations" do
    let(:milestone) { build(:milestone) }

    it "is valid" do
      expect(milestone).to be_valid
    end

    it "is valid without a title" do
      milestone.title = nil
      expect(milestone).to be_valid
    end

    it "is not valid without a description if status is empty" do
      milestone.status = nil
      milestone.description = nil
      expect(milestone).not_to be_valid
    end

    it "is valid without a description if status is present" do
      milestone.description = nil
      expect(milestone).to be_valid
    end

    it "is not valid without a milestoneable" do
      milestone.milestoneable_id = nil
      expect(milestone).not_to be_valid
    end

    it "is not valid if description and status are not present" do
      milestone.description = nil
      milestone.status_id = nil
      expect(milestone).not_to be_valid
    end

    it "is valid without status if description is present" do
      milestone.status_id = nil
      expect(milestone).to be_valid
    end
  end

  describe ".by_locale" do
    let(:author) { create(:user, data_consent: true, address: "Bevkova ulica 1") }
    let(:investment) { create(:budget_investment, author: author) }

    it "only includes milestones with a translation for the given locale" do
      english = I18n.with_locale(:en) do
        create(:milestone, milestoneable: investment, description: "English milestone")
      end
      spanish = I18n.with_locale(:es) do
        create(:milestone, milestoneable: investment, description: "Hito español")
      end

      expect(Milestone.by_locale(:en)).to contain_exactly(english)
      expect(Milestone.by_locale(:es)).to contain_exactly(spanish)
    end

    it "defaults to the current locale" do
      english = I18n.with_locale(:en) { create(:milestone, milestoneable: investment) }
      I18n.with_locale(:es) { create(:milestone, milestoneable: investment) }

      I18n.with_locale(:en) do
        expect(Milestone.by_locale).to contain_exactly(english)
      end
    end
  end

  describe ".published", :application_zone_west_of_system_zone do
    it "includes milestones published today" do
      todays_milestone = create(:milestone, publication_date: Time.current)

      expect(Milestone.published).to eq [todays_milestone]
    end

    it "does not include future milestones" do
      create(:milestone, publication_date: Date.tomorrow.beginning_of_day)

      expect(Milestone.published).to be_empty
    end
  end
end
