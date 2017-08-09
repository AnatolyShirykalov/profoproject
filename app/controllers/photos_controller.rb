class PhotosController < ApplicationController
  def create
    Photo.create! photo_params
    redirect_to request.env['HTTP_REFERER']
  end

  private
  def photo_params
    params.require(:photo).
      permit(*%i[user_id stage_id target enabled name description photo])
  end
end
