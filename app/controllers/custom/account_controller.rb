load Rails.root.join("app", "controllers", "account_controller.rb")

class AccountController < ApplicationController
  def account_params
    attributes = if @account.organization?
                   [:phone_number, :email_on_comment, :email_on_comment_reply, :newsletter,
                    organization_attributes: [:name, :responsible_name]]
                 else
                   [:username, :public_activity, :public_interests, :email_on_comment,
                    :email_on_comment_reply, :email_on_direct_message, :email_digest, :newsletter,
                    :official_position_badge, :recommended_debates, :recommended_proposals, :address]
                 end
    params.require(:account).permit(*attributes)
  end
end
