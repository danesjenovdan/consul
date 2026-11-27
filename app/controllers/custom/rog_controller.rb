class RogController < ApplicationController
    skip_authorization_check

    def log_in_with_document_number
        user = find_user_by_document_number(params[:document_number])

        if user
            sign_in(:user, user)
            redirect_to root_url
        else
            redirect_to new_user_session_path
        end
    end

    private

        # User normalizes document_number (strips non-alphanumerics, upcases),
        # and Rails applies that normalization to find_by arguments too.
        # Fall back to a raw comparison for records stored without normalization.
        def find_user_by_document_number(document_number)
            return if document_number.blank?

            User.find_by(document_number: document_number) ||
                User.where("document_number = ?", document_number).first
        end
end
