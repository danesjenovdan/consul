load Rails.root.join("app", "models", "milestone.rb")

class Milestone < ApplicationRecord
  # In this installation milestones are authored per locale (a separate milestone
  # for each language). Without this scope every milestone shows up in every
  # locale: the text falls back to whatever translation exists (or shows nothing)
  # while the locale-independent image always renders. Restrict milestones to the
  # ones that actually have a translation for the requested locale so only the
  # milestones written in the selected language are displayed.
  scope :by_locale, ->(locale = Globalize.locale) {
    joins(:translations).where(milestone_translations: { locale: locale }).distinct
  }
end
