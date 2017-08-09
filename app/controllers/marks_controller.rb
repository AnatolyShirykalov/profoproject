class MarksController < ApplicationController
  def create
    current_user.marks.create! mark_params
    redirect_to request.env['HTTP_REFERER']
  end

  private
  def mark_params
    params.require(:mark).permit(:mark, :content, :mark_type_id, :photo_id)
  end
end
