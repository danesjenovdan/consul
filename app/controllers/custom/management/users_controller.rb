class Management::UsersController < Management::BaseController

  private

    def user_params
      params.require(:user).permit(:document_type, :document_number, :username, :email, :date_of_birth, :address, :data_consent)
    end

end
