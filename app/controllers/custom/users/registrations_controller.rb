load Rails.root.join('app', 'controllers', 'users', 'registrations_controller.rb')

class Users::RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: [:create], honeypot: :home_address, scope: :user

  def sign_up_params
    params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
    params.require(:user).permit(:username, :email, :phone_number, :password,
                                 :password_confirmation, :terms_of_service, :locale,
                                 :document_type, :document_number,
                                 :redeemable_code, :use_redeemable_code, 
                                 :address, :consent_to_publish_name, :confirm_age, :data_consent)
  end
end