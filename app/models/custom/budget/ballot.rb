require_dependency Rails.root.join('app', 'models', 'budget', 'ballot').to_s

class Budget
  class Ballot < ApplicationRecord

    def different_heading_assigned?(heading)
      other_heading_ids = heading.group.heading_ids - [heading.id]
      lines.where(heading_id: other_heading_ids).exists? &&
      lines.where(heading_id: other_heading_ids).count >= heading.group.max_votable_headings
    end

  end
end