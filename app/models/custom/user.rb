require 'date'
require_dependency Rails.root.join('app', 'models', 'user').to_s

class User < ApplicationRecord

  validate :emso_number, on: :create
  validate :validate_data_consent, on: :create
  validate :validate_address, on: :create

  
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

  private

  def date_from_emso(emso)
    if emso[4] == '0'
      Date.parse('2' + emso[4] + emso[5] + emso[6] + '-' + emso[2] + emso[3] + '-' + emso[0] + emso[1])
    else
      Date.parse('1' + emso[4] + emso[5] + emso[6] + '-' + emso[2] + emso[3] + '-' + emso[0] + emso[1])
    end
  end

  def is_old_enough(birthday)
    date_limit = Date.parse('2005-02-26')
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
end



def is_valid_address?
  valid_address = [
    "Topol pri Medvodah",
    "Belo",
    "Brezovica pri Medvodah",
    "Tehovec",
    "Trnovec",
    "Setnica",
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
    "Verje",
    "Zgornje Pirniče",
    "Spodnje Pirniče",
    "Vikrče",
    "Zavrh pod Šmarno goro",
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
    "Spodnja Senica",
    "Zgornja Senica",
    "Ladja",
    "Seničica",
    "Golo Brdo",
    "Smlednik",
    "Valburga",
    "Hraše",
    "Dragočajna",
    "Moše",
    "Sora",
    "Rakovnik",
    "Dol",
    "Osolnik",
    "Vaše",
    "Goričane",
    "Zbilje",
    "Studenčice",
    "Žlebe"
  ];
r = /#{valid_address.join("|")}/ # assuming there are no special chars
print(r === address)
  return r === address
end