require_dependency Rails.root.join('app', 'models', 'officing', 'residence').to_s

class Officing::Residence

  # remove existing validators
  self.class_eval do
    puts _validators[:year_of_birth]
    # _validators[:year_of_birth]
    #   .find { |v| v.is_a? ActiveRecord::Validations::PresenceValidator }
    #   .attributes
    #   .delete(:year_of_birth)
  end

  def retrieve_census_data
    nil
    #@census_api_response = CensusCaller.new.call(document_type, document_number)
  end

  def allowed_age
    true
  end

  def residence_in_madrid
    true
  end

end
