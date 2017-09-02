module ApplicationHelper
  def sf_defaults
    {defaults: { input_html: {class: 'form-control'},
          wrapper_html: {class: 'col-sm'}
    }, html: {class: 'form-inline'} }
  end

  def no_turbolinks
    {no_turbolinks: true, turbolinks: false}
  end

  def vk_comment result
    (result[:by_user].map do |rt|
      msg = "#{rt[:user].name}:\n"
      cmt = []
      rt[:marks].each do |mark|
        msg += "#{mark[:type].name}: #{mark[:mark].mark}\n" if mark[:type].name != 'Комментарий'
        cmt.push mark[:mark].content unless mark[:mark].content.blank?
        cmt.push asset_url(mark[:mark].image1.url) unless mark[:mark].image1.path.nil?
        cmt.push asset_url(mark[:mark].image2.url) unless mark[:mark].image2.path.nil?
      end
      "#{msg}\n#{cmt.join("\n")}"
    end + begin
      [ vk_comment_sz(result) ]
    end).join("\n_______________\n")
  end

  def vk_comment_sz result
    "Совет зрителей\n" + result[:viewers].map do |mt, m|
      "#{mt}: #{m}"
    end.join("\n")
  end
end
