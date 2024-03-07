require_dependency Rails.root.join('app', 'controllers', 'management', 'users_controller').to_s

class Management::UsersController < Management::BaseController

  private

    def user_params
      params.require(:user).permit(:document_type, :document_number, :username, :email, :phone_number, :date_of_birth, :confirm_truth)
    end

end
