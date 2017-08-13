class PhotosController < ApplicationController
  before_action :authenticate_user!
  def new
    @stage = Stage.find_by slug: params[:stage]
    @photo = @stage.photos.new enabled: true
    @photo.src = params[:src]
    if request.xhr?
      render partial: 'form', layout: false, locals: {photo: @photo}
      return
    end
  end

  def create
    @photo = Photo.find_or_initialize_by photo_params
    src = params.require(:photo).permit(:src)[:src]
    if src
      @photo.photo = open(src)
      @photo.photo_file_name = URI.parse(src).path.split('/')[-1]
    end
    @photo.save!
    if request.xhr?
      render json: {ok: (@photo and @photo.persisted? ? true : false)}
      return
    end
    redirect_to request.env['HTTP_REFERER']
  end

  private
  def photo_fields
    %i[user_id stage_id target enabled name description photo]
  end

  def redices_photo_params
    params.require(:photo).permit(*(photo_fields[0..-2]))
  end

  def photo_params
    params.require(:photo).permit(*photo_fields)
  end
end
