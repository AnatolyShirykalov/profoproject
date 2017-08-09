class StagesController < ApplicationController
  def index
    #if users_signed_in?
    #  @partiable = current_user.partiable.preload(
    #  @juriable = current_user.juriable
    #end
    #@lookable =
  end

  def show
    @stage = Stage.preload(:tournament).find_by slug: params[:slug]
    @owe = @stage.tournament.photographs.find_by(id: current_user.id)
    @photo =  @stage.photos.find_or_initialize_by({
      user: current_user,
      enabled: true,
      target: 'stage',
    })
  end
end
