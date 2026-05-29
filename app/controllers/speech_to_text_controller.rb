class SpeechToTextController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check

  rate_limit to: 20,
             within: 15.minutes,
             by: -> { current_user.id },
             only: :create,
             with: -> { render_rate_limit_response }

  def create
    return render_audio_required_error if params[:audio_file].blank?
    return render_audio_too_large_error if params[:audio_file].size > 10.megabytes

    transcription = SpeechToText::Llm::Client.call(
      audio_file: params[:audio_file],
      locale: params[:locale]
    )

    if transcription.errors.any?
      render json: { errors: transcription.errors.join(", ") }, status: :unprocessable_entity
    else
      render json: { text: transcription.text, segments: transcription.segments }
    end
  end

  private

    def render_rate_limit_response
      render json: { errors: I18n.t("speech_to_text.errors.rate_limit_exceeded") }, status: :too_many_requests
    end

    def render_audio_required_error
      render json: { errors: I18n.t("speech_to_text.errors.audio_required") }, status: :unprocessable_entity
    end

    def render_audio_too_large_error
      render json: { errors: I18n.t("speech_to_text.errors.audio_too_large") }, status: :unprocessable_entity
    end
end
