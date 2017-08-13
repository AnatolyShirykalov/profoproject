class AlbumsController < ApplicationController
  include Vkontakt
  before_action :init_vk_cli

  def index
    @albums = @vk.photos.get_albums(owner_id: @gid, need_covers: true)
  end

  def show
    @stage = Stage.preload(:photos).current
    @photos = @vk.photos.get(owner_id: @gid, album_id: params[:id], photo_sizes: 1)
  end
end
