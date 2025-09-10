require "rails_helper"

describe "Admin LLM settings", :admin do
  context "Nothing is configured" do
    before do
      # Create fresh doubles for each test to avoid leakage
      config_double = double("config")
      context_double = double("context", config: config_double)

      allow(RemoteTranslations::Llm::Config).to receive_messages(
        providers: {},
        context: context_double
      )
    end

    scenario "Provider and model are disabled, but Settings render without errors" do
      visit admin_settings_path
      click_link "LLM Settings"

      expect(page).to have_content "LLM Provider"
    end
  end

  context "Required LLM setup is configured" do
    before do
      # Create fresh doubles for each test to avoid leakage
      config_double = double("config")
      context_double = double("context", config: config_double)

      # Stub RubyLLM providers to avoid real provider calls
      allow(RubyLLM::Providers).to receive(:constants).and_return([:OpenAI])
      stub_provider = Class.new do
        def self.configured?(config)
          true
        end
      end
      stub_const("RubyLLM::Providers::OpenAI", stub_provider)

      # Stub the config context to avoid real RubyLLM calls
      allow(RemoteTranslations::Llm::Config).to receive(:context).and_return(context_double)
    end

    scenario "Configure provider, model and enable usage" do
      # Ensure settings exist
      Setting["llm.provider"] = nil
      Setting["llm.model"] = nil
      Setting["llm.use_llm_for_translations"] = nil

      # Stub available providers and models so dropdowns are enabled
      allow(RemoteTranslations::Llm::Config).to receive(:providers).and_return({
        "OpenAI" => { id: "openai", enabled: true }
      })
      model_double = double(name: "gpt-4o-mini", id: "gpt-4o-mini")
      allow(RubyLLM).to receive_message_chain(:models, :by_provider).with(:openai).and_return([model_double])

      visit admin_settings_path
      click_link "LLM Settings"

      # Select provider
      provider_setting = Setting.find_by!(key: "llm.provider")
      within "#edit_setting_#{provider_setting.id}" do
        select "OpenAI", from: "setting_value"
      end

      # Provider selection triggers an ajax submit; wait until model row appears
      expect(page).to have_content "Model"

      # Select model
      model_setting = Setting.find_by!(key: "llm.model")
      within "#edit_setting_#{model_setting.id}" do
        select "gpt-4o-mini", from: "setting_value"
      end

      # After provider and model are set, the feature toggle row should appear
      expect(page).to have_content "Use LLM for content translations"

      # Wait for the feature toggle to be enabled and click it
      within "tr", text: "Use LLM for content translations" do
        expect(page).to have_button "No"
        click_button "No"
      end

      # Wait for the AJAX request to complete
      expect(page).to have_content "Value updated"

      # Verify settings persisted
      expect(Setting.find_by!(key: "llm.provider").reload.value).to eq "openai"
      expect(Setting.find_by!(key: "llm.model").reload.value).to eq "gpt-4o-mini"
      expect(Setting.find_by!(key: "llm.use_llm_for_translations").reload.value).to eq "active"
    end
  end
end
