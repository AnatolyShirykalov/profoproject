module ApplicationHelper
  def sf_defaults
    {defaults: { input_html: {class: 'form-control'},
          wrapper_html: {class: 'col-sm'}
    }, html: {class: 'form-inline'} }
  end

  def split_stage_mark(photo)
    @stage_mark_exist = []
    @stage_mark_not = []
    @stage.mark_types.each do |mark_type|
      mark = photo.marks.find_or_initialize_by(user: current_user, mark_type: mark_type)
      if mark.persisted?
        @stage_mark_exist.push(mark)
      else 
        @stage_mark_not.push(mark)
      end  
    end
    # binding.pry()  
  end 
end
