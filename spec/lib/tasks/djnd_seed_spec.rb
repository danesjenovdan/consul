require "rails_helper"

describe "rake db:djnd_seed" do
  let :run_rake_task do
    Rake.application.invoke_task("db:djnd_seed[avoid_log]")
  end

  it "seeds the database without errors" do
    expect { run_rake_task }.not_to raise_error
  end
end
