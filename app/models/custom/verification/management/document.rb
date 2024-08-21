load Rails.root.join("app", "models", "verification", "management", "document.rb")

class Verification::Management::Document
    def in_census?
        User.valid_emso?(self.document_number)
    end
end
