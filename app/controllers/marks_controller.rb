class MarksController < ApplicationController
  def create
    mark = current_user.marks.create mark_params
    flash[:errors] = mark.errors.messages.map{|k, v| "#{t("activerecord.attributes.mark.#{k}")} #{v.join(', ')}"}.join("\n")
    redirect_to request.env['HTTP_REFERER']
  end

  private
  def mark_params
    params.require(:mark).permit(:mark, :content, :mark_type_id, :photo_id)
  end
end
