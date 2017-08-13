class AlbumsController < ApplicationController
  before_action :init_vk_cli
  def index
    @albums = @vk.photos.get_albums(owner_id: @gid, need_covers: true)
  end

  def show
    @stage = Stage.preload(:photos).current
    @photos = @vk.photos.get(owner_id: @gid, album_id: params[:id], photo_sizes: 1)
    #@users = User.where(provider: 'vkontakte', uid: @photos.map(&:user_id).uniq).to_a
  end

  private
  def init_vk_cli
    authenticate_user!
    if current_user.role != 'admin'
      redirect_to '/about'
      return
    end
    @vk = VkontakteApi::Client.new Rails.application.secrets.protoproject_key
    @gid = Settings.ns('vk').group_id
  end
end
