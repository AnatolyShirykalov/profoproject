class StagesController < ApplicationController
  include Vkontakt
  before_action :init_vk_cli, only: :post

  def index
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

  def results
    @stage = Stage.find_by slug: params[:slug]
  end

  def post
    @stage = Stage.find_by slug: params[:slug]
    @vk.wall.post(owner_id: @gid, message: @stage.to_rows.map{|r| r.join("\t")}.join("\n"))
    render json: {ok: true}
  end

end
