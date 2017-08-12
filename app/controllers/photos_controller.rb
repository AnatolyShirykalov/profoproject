class PhotosController < ApplicationController
  def new
    @stage = Stage.find_by slug: params[:stage]
    @photo = @stage.photos.new enabled: true
    if request.xhr?
      render partial: 'form', layout: false, photo: @photo
      return
    end
  end

  def create
    @photo = Photo.create! photo_params
    if request.xhr?
      render json: {ok: true}
    end
    redirect_to request.env['HTTP_REFERER']
  end

  private
  def photo_params
    params.require(:photo).
      permit(*%i[user_id stage_id target enabled name description photo])
  end
end
