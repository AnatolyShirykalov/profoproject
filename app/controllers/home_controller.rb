class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @stage = Stage.enabled.order(:deadline).last
    if current_user.role != 'admin'
      unless @stage.tournament.juries.find_by(id: current_user.id)
        flash[:errors] = "Вы не являетесь членом жюри данного этапа"
        redirect_to '/about'
        return
      end
      redirect_to stage_path(@stage)
    end
    @photographs = Tournament.first.photographs
    @juries = Tournament.first.juries
  end
end
