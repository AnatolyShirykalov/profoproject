class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @stage = Stage.current
    if current_user.role != 'admin'
      unless @stage.markable? current_user
        flash[:errors] = 'Вы не являетесь членом жюри данного этапа'
        redirect_to '/about'
        return
      end
      redirect_to stage_path(@stage)
    end
    @stages      = Stage.closed
    @photographs = @stage.tournament.enabled_photographs
    @juries      = @stage.tournament.juries
    @viewers     = @stage.tournament.viewers
  end
end
