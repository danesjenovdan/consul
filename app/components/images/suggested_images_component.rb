class Images::SuggestedImagesComponent < ApplicationComponent
  attr_reader :title, :description

  def initialize(title, description)
    @title = title
    @description = description
  end

  def suggested_images
    return [] if title.blank? && description.blank?

    results = response.results
    return [] if results.blank?

    results.photos
  end

  def has_errors?
    response.errors.any?
  end

  def error_messages
    response.errors
  end

  private

    def response
      @response ||= ImageSuggestions::Llm::Client.call(
        title: title,
        description: description,
        rate_limit_cache_key: rate_limit_cache_key
      )
    end

    def rate_limit_cache_key
      return "image_suggestions_rate_limit" unless current_user

      "image_suggestions_rate_limit_#{current_user.id}"
    end
end
