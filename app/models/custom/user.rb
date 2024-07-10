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
    # Bistrica
    valid_addresses = [
      'Begunjska cesta',
      'Bistrica',
      'Cesta na Loko',
      'Cesta Ste Marie aux Mines 26',
      'Cesta Ste Marie aux Mines 30',
      'Cesta Ste Marie aux Mines 32',
      'Deteljica',
      'Kovorska cesta',
      'Na Logu',
      'Pod gradom',
      'Pod Šijo',
      'Pot na Bistriško planino',
      'Spodnja Bistrica',
      'Zelenica',
      'Na jasi',
      'Ročevnica',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 16
    end

    # check Kovor
    valid_addresses = [
      'Brdo',
      'Hudo',
      'Brezovo',
      'Cesta na Brdo',
      'Cesta na Hudo',
      'Glavna cesta',
      'Graben',
      'Iženkovo',
      'Kriška cesta',
      'Pod gozdom',
      'Pod skalco',
      'Praproše',
      'Srednja pot',
      'Stagne',
      'Vetrovo',
      'Loka',
      'Zvirče',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 15
    end

    # check Sebenje
    valid_addresses = [
      'Breg ob Bistrici',
      'Retnje 12',
      'Retnje 12a',
      'Retnje 12b',
      'Retnje 13',
      'Retnje 14',
      'Retnje 15',
      'Retnje 15a',
      'Retnje 16',
      'Retnje 17',
      'Retnje 17a',
      'Retnje 17b',
      'Retnje 18a',
      'Retnje 19',
      'Retnje 20',
      'Retnje 22',
      'Retnje 23a',
      'Retnje 24',
      'Retnje 25',
      'Retnje 26',
      'Retnje 28a',
      'Retnje 30',
      'Retnje 39',
      'Retnje 40',
      'Retnje 41',
      'Retnje 41a',
      'Retnje 43',
      'Retnje 44',
      'Retnje 44a',
      'Retnje 45',
      'Retnje 45b',
      'Retnje 45d',
      'Retnje 46',
      'Retnje 47',
      'Retnje 48',
      'Retnje 52',
      'Retnje 53',
      'Retnje 54',
      'Retnje 56',
      'Retnje 58',
      'Retnje 59',
      'Sebenje',
      'Žiganja vas',
    ]

    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/i # assuming there are no special chars
    if r === address
      return 14
    end

    # check Brezje
    valid_addresses = [
      'Brezje pri Tržiču',
      'Hudi Graben',
      'Hušica',
      'Visoče',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 17
    end

    # check Ravne
    valid_addresses = [
      'Koroška cesta 27a',
      'Koroška cesta 31',
      'Koroška cesta 33a',
      'Koroška cesta 68',
      'Koroška cesta 84',
      'Koroška cesta 86',
      'Koroška cesta 88',
      'Koroška cesta 90',
      'Koroška cesta 92',
      'Koroška cesta 94',
      'Koroška cesta 96',
      'Koroška cesta 98',
      'Muzejska ulica 12',
      'Pot na Zali Rovt',
      'Ravne',
      'Za jezom',
    ]

    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/i # assuming there are no special chars
    if r === address      
      return 7
    end

    # check Tržič – mesto
    valid_addresses = [
      'Čadovlje pri Tržiču',
      'Slap',
      'Balos',
      'Blejska cesta',
      'Cankarjeva cesta',
      'Cerkvena ulica',
      'Cesta Ste Marie aux Mines',
      'Čevljarska ulica',
      'Fužinska ulica',
      'Koroška cesta',
      'Kosarska ulica',
      'Kovaška ulica',
      'Kranjska cesta',
      'Kukovniška pot',
      'Kurnikova pot',
      'Muzejska ulica',
      'Paradiž',
      'Partizanska ulica',
      'Pot na pilarno',
      'Predilniška cesta',
      'Prehod',
      'Preska',
      'Šolska ulica',
      'Trg svobode',
      'Usnjarska ulica',
      'Virje',
      'Za Mošenikom',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 6
    end

    # check Jelendol
    valid_addresses = [
      'Dolina',
      'Jelendol',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 10
    end

    # check Križe
    valid_addresses = [
      'Gozd',
      'Cesta Kokrškega odreda',
      'Hladnikova ulica',
      'Planinska pot',
      'Pod Pogovco',
      'Pod Slemenom',
      'Pot na Močila',
      'Snakovška cesta',
      'Vrtna ulica',
      'Retnje',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 12
    end

    # check Lom pod Storžičem
    valid_addresses = [
      'Grahovše',
      'Lom pod Storžičem',
      'Potarje',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 9
    end

    # check Leše
    valid_addresses = [
      'Leše',
      'Paloviče',
      'Popovo',
      'Vadiče',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 18
    end

    # check Senično
    valid_addresses = [
      'Novake',
      'Senično',
      'Spodnje Vetrno',
      'Zgornje Vetrno',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 13
    end

    # check Podljubelj
    valid_addresses = [
      'Podljubelj',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 8
    end

    # check Pristava
    valid_addresses = [
      'Mlaka',
      'Podvasca',
      'Pot na polje',
      'Pristavška cesta',
      'Purgarjeva ulica',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 11
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
    date_limit = Date.parse('2009-06-12')
    if date_limit < birthday
      return false
    end
    true
  end

  def valid_emso_number?
    if (Rails.env.development? && email == 'admin@consul.dev') || Rails.env.test?
      return true
    end
    if document_number.length == 13
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
    end
    false
  end

  # regex check if address is valid
  def is_valid_address?
    valid_addresses = [
      # Bistrica
      'Begunjska cesta',
      'Bistrica',
      'Cesta na Loko',
      'Cesta Ste Marie aux Mines',
      'Deteljica',
      'Kovorska cesta',
      'Na Logu',
      'Pod gradom',
      'Pod Šijo',
      'Pot na Bistriško planino',
      'Spodnja Bistrica',
      'Zelenica',
      'Na jasi',
      'Ročevnica',

      # Kovor
      'Brdo',
      'Hudo',
      'Brezovo',
      'Cesta na Brdo',
      'Cesta na Hudo',
      'Glavna cesta',
      'Graben',
      'Iženkovo',
      'Kriška cesta',
      'Pod gozdom',
      'Pod skalco',
      'Praproše',
      'Srednja pot',
      'Stagne',
      'Vetrovo',
      'Loka',
      'Zvirče',

      # Sebenje
      'Breg ob Bistrici',
      'Retnje',
      'Sebenje',
      'Žiganja vas',

      # Brezje
      'Brezje pri Tržiču',
      'Hudi Graben',
      'Hušica',
      'Visoče',

      # Tržič – mesto
      'Čadovlje pri Tržiču',
      'Slap',
      'Balos',
      'Blejska cesta',
      'Cankarjeva cesta',
      'Cerkvena ulica',
      'Čevljarska ulica',
      'Fužinska ulica',
      'Koroška cesta',
      'Kosarska ulica',
      'Kovaška ulica',
      'Kranjska cesta',
      'Kukovniška pot',
      'Kurnikova pot',
      'Muzejska ulica',
      'Paradiž',
      'Partizanska ulica',
      'Pot na pilarno',
      'Predilniška cesta',
      'Prehod',
      'Preska',
      'Šolska ulica',
      'Trg svobode',
      'Usnjarska ulica',
      'Virje',
      'Za Mošenikom',

      # Jelendol
      'Dolina',
      'Jelendol',

      # Križe
      'Gozd',
      'Cesta Kokrškega odreda',
      'Hladnikova ulica',
      'Planinska pot',
      'Pod Pogovco',
      'Pod Slemenom',
      'Pot na Močila',
      'Snakovška cesta',
      'Vrtna ulica',

      # Lom pod Storžičem
      'Grahovše',
      'Lom pod Storžičem',
      'Potarje',

      # Leše
      'Leše',
      'Paloviče',
      'Popovo',
      'Vadiče',

      # Senično
      'Novake',
      'Senično',
      'Spodnje Vetrno',
      'Zgornje Vetrno',

      # Podljubelj
      'Podljubelj',

      # Pristava
      'Mlaka',
      'Podvasca',
      'Pot na polje',
      'Pristavška cesta',
      'Purgarjeva ulica',

      # Ravne
      'Pot na Zali Rovt',
      'Ravne',
      'Za jezom',
    ];
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    return r === address
  end
end
