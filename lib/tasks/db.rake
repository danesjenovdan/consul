namespace :db do
  desc "Resets the database and loads it from db/dev_seeds.rb"
  task :dev_seed, [:tenant] => [:environment] do |_, args|
    I18n.enforce_available_locales = false
    Tenant.switch(args[:tenant]) { load(Rails.root.join("db", "dev_seeds.rb")) }
  end

  desc "Mask IPs collected with Ahoy"
  task mask_ips: :environment do
    ApplicationLogger.new.info "Masking tracked IPs collected with Ahoy"

    Tenant.run_on_each do
      Visit.find_each do |visit|
        visit.update_column :ip, Ahoy.mask_ip(visit.ip)
      end
    end
  end

  desc "Resets the database and loads it from db/djnd_seeds.rb"
  task :djnd_seed, [:print_log] => [:environment] do |t, args|
    @avoid_log = args[:print_log] == "avoid_log"
    I18n.enforce_available_locales = false
    load(Rails.root.join("db", "djnd_seeds.rb"))
  end

  desc "Resets the database and loads it from db/djnd_seeds.rb"
  task :djnd_seed, [:print_log] => [:environment] do |t, args|
    @avoid_log = args[:print_log] == "avoid_log"
    I18n.enforce_available_locales = false
    load(Rails.root.join("db", "djnd_seeds.rb"))
  end
end
