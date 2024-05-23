class RogController < ApplicationController
    skip_authorization_check
    
    def log_in_with_document_number
        sign_in(:user, User.find_by(document_number: params[:document_number]))
        redirect_to root_url
    end
end
