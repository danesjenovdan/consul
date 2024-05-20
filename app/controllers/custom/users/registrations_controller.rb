require_dependency Rails.root.join('app', 'controllers', 'users', 'registrations_controller').to_s

class Users::RegistrationsController < Devise::RegistrationsController
  def sign_up_params
    params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
    params.require(:user).permit(:username, :email, :phone_number, :password,
                                 :password_confirmation, :terms_of_service, :locale,
                                 :document_type, :document_number,
                                 :redeemable_code, :use_redeemable_code, :data_consent)
  end
end
