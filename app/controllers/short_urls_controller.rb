class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
  end

  def create
    short_url = ShortUrl.new(full_url: permitted_params_for_create['full_url'])
    if short_url.save
      render json: short_url.as_json, status: 200
    else
      render json: { errors: short_url.errors.full_messages.as_json }, status: 400
    end
  end

  def show
  end

  private

  def permitted_params_for_create
    params.permit(:full_url)
  end
end
