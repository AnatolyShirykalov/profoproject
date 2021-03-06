require 'cloner'

class Dl < Cloner::Base
  no_commands do
    def rails_path
      File.expand_path("../../../config/environment", __FILE__)
    end
    def ssh_host
      'shirykalov.tk'
    end
    def ssh_user
      'profoproject'
    end
    def remote_dump_path
      '/home/profoproject/tmp_dump'
    end
    def remote_app_path
      '/home/profoproject/app/current'
    end
  end

  desc "download", "clone files and DB from production"
  def download
    load_env
    clone_db
    rsync_public("system")
  end
end
