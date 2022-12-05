require 'date'
require_dependency Rails.root.join('app', 'models', 'user').to_s

class User < ApplicationRecord

  validate :emso_number, on: :create
  validate :validate_data_consent, on: :create
  validate :validate_address, on: [:create, :update]
  validates :email, on: :create, presence: true
  
  def validate_data_consent
    unless data_consent
      errors.add(:data_consent, I18n.t('custom.errors.data_consent'))
    end
  end

  def validate_address
    errors.add(:address, I18n.t('activerecord.errors.models.user.attributes.address.invalid')) unless is_valid_address?
  end

  def emso_number
    unless organization
      errors.add(:document_number, I18n.t('activerecord.errors.models.user.attributes.document_number.invalid')) unless valid_emso_number?
    end
  end

  def heading_id
    # check medvode center
    valid_addresses = [
      # medvode center
      "Arharjeva ulica",
      "Barletova cesta 2",
      "Cesta komandanta Staneta",
      "Cesta na Senico",
      "Cesta na Svetje",
      "Cesta ob Sori",
      "Cesta talcev",
      "Čarmanova ulica",
      "Čelesnikova ulica",
      "Dimčeva ulica",
      "Donova cesta",
      "Finžgarjeva ulica",
      "Gorenjska cesta",
      "Grajzerjeva ulica",
      "Jamnikova ulica",
      "Kebetova ulica",
      "Klanska ulica",
      "Kržišnikova ulica",
      "Kuraltova ulica",
      "Ostrovrharjeva ulica",
      "Medvoška cesta",
      "Podvizova ulica",
      "Seškova cesta",
      "Šetinova ulica",
      "Šlosarjeva ulica",
      "Šmalčeva ulica",
      "Štalčeva ulica",
      "Tehovnikova ulica",
      "Trampuževa ulica",
      "Turkova ulica",
      "Ulica Ivanke Ovijač",
      "Ulica k studencu",
      "Ulica ob gozdu",
      "Ulica Simona Jenka",
      "Višnarjeva ulica",
      "Zbiljska cesta",
      "Žontarjeva ulica",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 19
    end

    # check preska
    valid_addresses = [
      "Barletova cesta",
      "Bečanova ulica",
      "Bergantova cesta",
      "Bernikova ulica",
      "Bizantova cesta",
      "Bogatajeva ulica",
      "Cesta ob železnici",
      "Cesta v Bonovec",
      "Cesta v Žlebe",
      "Dobnikarjeva ulica",
      "Hrastarjeva ulica",
      "Iztokova ulica",
      "Kalanova ulica",
      "Kurirska cesta",
      "Na Čerenu",
      "Preška cesta",
      "Škofjeloška cesta",
      "Trilerjeva ulica",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 21
    end

    # check polhograjci 1
    valid_addresses = [
      "Belo",
      "Brezovica pri Medvodah",
      "Topol pri Medvodah",
      "Tehovec",
      "Trnovec",
      "Setnica",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 18
    end

    # check pirniče
    valid_addresses = [
      "Verje",
      "Vikrče",
      "Zgornje Pirniče",
      "Spodnje Pirniče",
      "Zavrh pod šmarno goro",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 20
    end

    # check senica
    valid_addresses = [
      "Ladja",
      "Spodnja Senica",
      "Zgornja Senica",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 22
    end

    # check seničica
    valid_addresses = [
      "Golo Brdo",
      "Seničica",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 23
    end

    # check smlednik
    valid_addresses = [
      "Valburga",
      "Smlednik",
      "Dragočajna",
      "Hraše",
      "Moše",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 17
    end

    # check sora
    valid_addresses = [
      "Sora",
      "Osolnik",
      "Rakovnik",
      "Dol",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 24
    end

    # check vaše goričane
    valid_addresses = [
      "Goričane",
      "Vaše",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 25
    end

    # check zbilje
    valid_addresses = [
      "Zbilje",  
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 26
    end

    # check polhograjci 2
    valid_addresses = [
      "Studenčice",
      "Žlebe",
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 27
    end
  end

  private

  def date_from_emso(emso)
    if emso[4] == '0'
      Date.parse('2' + emso[4] + emso[5] + emso[6] + '-' + emso[2] + emso[3] + '-' + emso[0] + emso[1])
    else
      Date.parse('1' + emso[4] + emso[5] + emso[6] + '-' + emso[2] + emso[3] + '-' + emso[0] + emso[1])
    end
  end

  def is_old_enough(birthday)
    date_limit = Date.parse('2005-12-13')
    if date_limit < birthday
      return false
    end
    true
  end

  def valid_emso_number?
    if (Rails.env.development? && email == 'admin@consul.dev') || Rails.env.test?
      return true
    end
    if /[0123]\d[01]\d[09]\d\d\d{6}/.match(document_number)
      if document_number[12].to_i == 11 - (
      (
      ((document_number[0].to_i + document_number[6].to_i) * 7) +
        ((document_number[1].to_i + document_number[7].to_i) * 6) +
        ((document_number[2].to_i + document_number[8].to_i) * 5) +
        ((document_number[3].to_i + document_number[9].to_i) * 4) +
        ((document_number[4].to_i + document_number[10].to_i) * 3) +
        ((document_number[5].to_i + document_number[11].to_i) * 2)
      ) % 11
      )
        return is_old_enough(date_from_emso(document_number))
      elsif document_number[12].to_i == (
      ((document_number[0].to_i + document_number[6].to_i) * 7) +
        ((document_number[1].to_i + document_number[7].to_i) * 6) +
        ((document_number[2].to_i + document_number[8].to_i) * 5) +
        ((document_number[3].to_i + document_number[9].to_i) * 4) +
        ((document_number[4].to_i + document_number[10].to_i) * 3) +
        ((document_number[5].to_i + document_number[11].to_i) * 2)
      ) % 11
        return is_old_enough(date_from_emso(document_number))
      else
        return false
      end
    end
    false
  end

  # regex check if address is valid
  # this list of addresses is for 2022
  def is_valid_address?
    valid_addresses = [
      # medvode center
      "Arharjeva ulica",
      "Barletova cesta 2",
      "Cesta komandanta Staneta",
      "Cesta na Senico",
      "Cesta na Svetje",
      "Cesta ob Sori",
      "Cesta talcev",
      "Čarmanova ulica",
      "Čelesnikova ulica",
      "Dimčeva ulica",
      "Donova cesta",
      "Finžgarjeva ulica",
      "Gorenjska cesta",
      "Grajzerjeva ulica",
      "Jamnikova ulica",
      "Kebetova ulica",
      "Klanska ulica",
      "Kržišnikova ulica",
      "Kuraltova ulica",
      "Ostrovrharjeva ulica",
      "Medvoška cesta",
      "Podvizova ulica",
      "Seškova cesta",
      "Šetinova ulica",
      "Šlosarjeva ulica",
      "Šmalčeva ulica",
      "Štalčeva ulica",
      "Tehovnikova ulica",
      "Trampuževa ulica",
      "Turkova ulica",
      "Ulica Ivanke Ovijač",
      "Ulica k studencu",
      "Ulica ob gozdu",
      "Ulica Simona Jenka",
      "Višnarjeva ulica",
      "Zbiljska cesta",
      "Žontarjeva ulica",
      
      # Preska
      "Barletova cesta (vse razen št. 2)",
      "Bečanova ulica",
      "Bergantova cesta",
      "Bernikova ulica",
      "Bizantova cesta",
      "Bogatajeva ulica",
      "Cesta ob železnici",
      "Cesta v Bonovec",
      "Cesta v Žlebe",
      "Dobnikarjeva ulica",
      "Hrastarjeva ulica",
      "Iztokova ulica",
      "Kalanova ulica",
      "Kurirska cesta",
      "Na Čerenu",
      "Preška cesta",
      "Škofjeloška cesta",
      "Trilerjeva ulica",

      "Belo",
      "Brezovica pri Medvodah",
      "Dol",
      "Dragočajna",
      "Golo Brdo",
      "Goričane",
      "Hraše",
      "Ladja",
      "Moše",
      "Osolnik",
      "Rakovnik",
      "Seničica",
      "Setnica",
      "Smlednik",
      "Sora",
      "Spodnja Senica",
      "Spodnje Pirniče",
      "Studenčice",
      "Tehovec",
      "Topol pri Medvodah",
      "Trnovec",
      "Valburga",
      "Vaše",
      "Verje",
      "Vikrče",
      "Zavrh pod šmarno goro",
      "Zbilje",
      "Zgornja Senica",
      "Zgornje Pirniče",
      "Žlebe",
    ];
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    return r === address
  end
end
