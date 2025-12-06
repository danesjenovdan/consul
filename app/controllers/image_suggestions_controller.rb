class ImageSuggestionsController < ApplicationController
  include DirectUploadsHelper
  include ActionView::Helpers::UrlHelper

  before_action :authenticate_user!
  skip_authorization_check

  def create
    @resource_type = params[:resource_type]
    @resource_id = params[:resource_id]
    @resource_attributes = params.require(@resource_type.parameterize.underscore).permit!.except(:subtitle)
    respond_to do |format|
      format.js
    end
  end

  def attach
    attachment_params_hash = attachment_params.merge(user: current_user)
    @direct_upload = DirectUpload.new(attachment_params_hash)

    if @direct_upload.valid?
      @direct_upload.save_attachment
      @direct_upload.relation.set_cached_attachment_from_attachment

      render json: { cached_attachment: @direct_upload.relation.cached_attachment,
                     filename: @direct_upload.relation.attachment_file_name,
                     destroy_link: render_destroy_upload_link(@direct_upload),
                     attachment_url: polymorphic_path(@direct_upload.relation.attachment) }
    else
      render json: { errors: @direct_upload.errors[:attachment].join(", ") },
             status: :unprocessable_entity
    end
  end

  private

    def attachment_params
      {
        resource_type: params[:resource_type],
        resource_id: params[:resource_id],
        resource_relation: "image",
        attachment: ImageSuggestions::Pexels.download_as_attachment(params[:id])
      }
    end
end
