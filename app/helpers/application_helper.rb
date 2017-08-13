module ApplicationHelper
  def sf_defaults
    {defaults: { input_html: {class: 'form-control'},
          wrapper_html: {class: 'col-sm'}
    }, html: {class: 'form-inline'} }
  end

  def no_turbolinks
    {no_turbolinks: true, turbolinks: false}
  end
end
