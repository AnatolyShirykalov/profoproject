module Vkontakt
  extend ActiveSupport::Concern
  included do
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
end
