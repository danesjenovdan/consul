require_dependency Rails.root.join('app', 'models', 'budget', 'heading').to_s

class Budget
  class Heading < ApplicationRecord

    translates :name, touch: true
    include Globalizable

  end
end