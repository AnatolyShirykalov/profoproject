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
    result[:by_user].map do |rt|
      msg = "#{rt[:user].name}:\n"
      cmt = ''
      rt[:marks].each do |mark|
        msg += "#{mark[:type].name}: #{mark[:mark].mark}\n" if mark[:type].name != 'Комментарий'
        cmt += mark[:mark].content
      end
      "#{msg}\n#{cmt}"
    end.join("\n_______________\n")
  end
end
