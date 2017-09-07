class StagesController < ApplicationController
  include Vkontakt
  before_action :init_vk_cli, only: %i[post post_comments]
  before_action :authenticate_user!, only: %i[show results]

  def index
  end

  def show
    @stage = Stage.preload(:tournament).find_by slug: params[:slug]
    return render_error(404) if @stage.nil?
    @owe = @stage.tournament.photographs.find_by(id: current_user.id)
    @photos = @stage.photos.unmarked_by(current_user, @stage)
    @photos = @stage.photos if params[:all]
    @photo =  @stage.photos.find_or_initialize_by({
      user: current_user,
      enabled: true,
      target: 'stage',
    })
  end

  def results
    @stage = Stage.find_by slug: params[:slug]
    @jps = JPS.new @stage
  end

  def post
    @stage = Stage.find_by slug: params[:slug]
    @vk.wall.post(owner_id: @gid, message: @stage.to_rows.map{|r| r.join("\t")}.join("\n"))
    render json: {ok: true}
  end

  def post_comments
    @stage = Stage.find_by slug: params[:slug]
    @stage.results.each do |result|
      up_data = @vk.photos.get_upload_server({
        group_id: @gid[1..-1],
        album_id: params[:album_id]
      })
      url = up_data['upload_url']
      ph = result[:photo]
      r = VkontakteApi.upload({
        url: url,
        photo: [ph.photo.path, ph.photo_content_type]
      })
      r.caption = "#{result[:user].name} «#{ph.name}»"
      sr = @vk.photos.save(r)

      message = result[:by_user].map do |rt|
        msg = "#{rt[:user].name}:\n"
        cmt = ''
        rt[:marks].each do |mark|
          msg += "#{mark[:type].name}: #{mark[:mark].mark}\n" if mark[:type].name != 'Комментарий'
          cmt += mark[:mark].content
        end
        "#{msg}\n#{cmt}"
      end.join("\n_______________\n")
      send_comment = proc do |args|
        @vk.photos.create_comment(args)
      end
      args = ({
        photo_id: sr.first.pid,
        owner_id: @gid,
        message: message,
        from_group: true,
      })
      woodpicker VkontakteApi::Error, args, &send_comment
    end
    render json: {ok: true}
  rescue => e
    logger.error(e.message)
    logger.error(e.backtrace)
    render json: {ok: false, message: e.message, backtrace: e.backtrace}
  end

  private
  def woodpicker(error, args, &pr)
    sleep 2
    pr.call(args)
  rescue error => e
    logger.error(e.message)
    logger.error(e.backtrace)
    puts e.message
    puts e.backtrace
    puts "___________\n\nsleep 2"
    sleep 2
    woodpicker(error, args, &pr)
  end
end
