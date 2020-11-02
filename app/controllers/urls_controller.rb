class UrlsController < ApplicationController
  def create    
    service = Urls::Creator.new
    service.url = create_params[:url]
    service.base_url = request.base_url
    return render json: service.errors.to_h, status: 400 unless service.valid?

    result = service.call
    render json: { url: result }, status: 202
  end

  def show
    service = Urls::Fetcher.new
    service.slug = params[:slug]

    result = service.call
    if result 
      render json: { url: result }
    else
      render :not_found
    end
  end

  def stats
    service = Urls::Stats.new
    service.slug = params[:url_slug]
    result = service.call

    if result
      render json: { stats: result }
    else
      render :not_found
    end
  end

  private

  def create_params
    params.permit(:url)
  end
end
