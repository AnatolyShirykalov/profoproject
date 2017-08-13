class MarksController < ApplicationController
  def create
    @stage = Stage.current
    @photo = Photo.find(mark_params[:photo_id])
    mark = current_user.marks.create mark_params
    flash[:errors] = mark.errors.messages.map{|k, v| "#{t("activerecord.attributes.mark.#{k}")} #{v.join(', ')}"}.join("\n")
    if request.xhr?
      render partial: 'marks/under_photo', locals: {photo: @photo}, layout: false
      return
    end
    redirect_to request.env['HTTP_REFERER']
  end

  private
  def mark_params
    params.require(:mark).permit(:mark, :content, :mark_type_id, :photo_id)
  end
end
