require 'date'
load Rails.root.join('app', 'models', 'user.rb')

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
    # Ankaran vzhod
    valid_addresses = [
      'Na Logu',
      'Železniška cesta',
      'Rožnik',
      'Ivančičeva cesta',
      'Cesta na Prisojo',
      'Pod Vrhom',
      'Oljčna pot',
      'Jadranska cesta' # ta se ponovi, tako da pazi z naslovi
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 4
    end

    # Ankaran center
    valid_addresses = [
      'Oljčna pot',
      'Pervanjeva ulica',
      'Bertokova ulica',
      'Pot na Brido',
      'Srebrničeva ulica',
      'Regentova ulica',
      'Hrvatinova ulica',
      'Vlahovičeva ulica',
      'Bevkova ulica',
      'Kocjančičeva ulica',
      'Cahova ulica',
      'Ulica Rudija Mahniča',
      'Tomažičeva ulica',
      'Larisova ulica',
      'Frenkova ulica',
      'Razgledna pot',
      'Jadranska cestače',
    ]
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    if r === address
      return 5
    end

    # Ankaran zahod
    valid_addresses = [
      'Vinogradniška pot',
      'Lazaret',
      'Jadranska cesta',
    ]

    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/i # assuming there are no special chars
    if r === address
      return 3
    end
  end

  def self.date_from_emso(emso)
    if emso[4] == '0'
      Date.parse('2' + emso[4] + emso[5] + emso[6] + '-' + emso[2] + emso[3] + '-' + emso[0] + emso[1])
    else
      Date.parse('1' + emso[4] + emso[5] + emso[6] + '-' + emso[2] + emso[3] + '-' + emso[0] + emso[1])
    end
  end

  def self.is_old_enough(birthday)
    date_limit = Date.parse('2005-12-13') # TODO make this a constant
    if date_limit < birthday
      return false
    end
    true
  end

  def self.valid_emso?(emso)
    if emso.length == 13
      if /[0123]\d[01]\d[09]\d\d\d{6}/.match(emso)
        if emso[12].to_i == 11 - (
        (
        ((emso[0].to_i + emso[6].to_i) * 7) +
          ((emso[1].to_i + emso[7].to_i) * 6) +
          ((emso[2].to_i + emso[8].to_i) * 5) +
          ((emso[3].to_i + emso[9].to_i) * 4) +
          ((emso[4].to_i + emso[10].to_i) * 3) +
          ((emso[5].to_i + emso[11].to_i) * 2)
        ) % 11
        )
          return is_old_enough(date_from_emso(emso))
        elsif emso[12].to_i == (
        ((emso[0].to_i + emso[6].to_i) * 7) +
          ((emso[1].to_i + emso[7].to_i) * 6) +
          ((emso[2].to_i + emso[8].to_i) * 5) +
          ((emso[3].to_i + emso[9].to_i) * 4) +
          ((emso[4].to_i + emso[10].to_i) * 3) +
          ((emso[5].to_i + emso[11].to_i) * 2)
        ) % 11
          return is_old_enough(date_from_emso(emso))
        else
          return false
        end
      end
    end
    false
  end

  private

  def valid_emso_number?
    if (Rails.env.development? && email == 'admin@consul.dev') || Rails.env.test?
      return true
    end
    User.valid_emso?(document_number)
  end

  # regex check if address is valid
  def is_valid_address?
    valid_addresses = [
      # Ankaran vzhod
      'Na Logu',
      'Železniška cesta',
      'Rožnik',
      'Ivančičeva cesta',
      'Cesta na Prisojo',
      'Pod Vrhom',
      'Oljčna pot',
      'Jadranska cesta', # ta se ponovi, tako da pazi z naslovi

      # Ankaran center
      'Oljčna pot',
      'Pervanjeva ulica',
      'Bertokova ulica',
      'Pot na Brido',
      'Srebrničeva ulica',
      'Regentova ulica',
      'Hrvatinova ulica',
      'Vlahovičeva ulica',
      'Bevkova ulica',
      'Kocjančičeva ulica',
      'Cahova ulica',
      'Ulica Rudija Mahniča',
      'Tomažičeva ulica',
      'Larisova ulica',
      'Frenkova ulica',
      'Razgledna pot',
      'Jadranska cestače',

      # Ankaran zahod
      'Vinogradniška pot',
      'Lazaret',
      'Jadranska cesta',
    ];
    escaped_addresses = valid_addresses.map { |valid_address| Regexp.escape(valid_address)}
    r = /#{escaped_addresses.join("|")}/ # assuming there are no special chars
    return r === address
  end
end
