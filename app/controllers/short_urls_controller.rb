class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  def index
    urls = ShortUrl.order(click_count: :desc).limit(100)
    render json: { urls: urls.as_json }, status: 200
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
    short_code = permitted_params_for_show['id']
    id = ShortUrl.id_from_short_code(short_code)
    begin
      short_url = ShortUrl.find(id)
      short_url.increment!(:click_count)
      redirect_to short_url.full_url
    rescue
      render json: {}, status: 404
    end
  end

  private

  def permitted_params_for_create
    params.permit(:full_url)
  end

  def permitted_params_for_show
    params.permit(:id)
  end
end
