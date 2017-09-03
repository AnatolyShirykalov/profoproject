class JPS
  attr_accessor :juries, :viewers, :photographs, :stages, :photos, :marks, :mark_types
  def initialize(stage)
    tournament = stage.tournament
    @juries = tournament.juries.to_a
    @viewers = tournament.viewers.to_a
    @photographs = tournament.photographs.preload(:photos).to_a
    @enabled_photographs = tournament.enabled_photographs.preload(:photos).to_a
    @stages = tournament.stages.preload(:mark_types).enabled.
                                where('deadline <= ?', stage.deadline)
    @photos = @photographs.map(&:photos).inject(:+).
                          select{|photo| photo.stage_id.in? @stages.map(&:id)}
    @marks = Mark.where(user: @juries + @viewers, photo: @photos).to_a
    @mark_types = @stages.map(&:mark_types).inject(:|)
  end

  def elems(*args)
    ret = @marks
    args.each do |arg|
      return [] unless arg.class.in? [User, Stage, MarkType, Symbol]
      ret = send("by_#{arg.class.to_s.underscore}", ret, arg)
    end
    ret
  end

  def elem(*args)
    elems(*args).first
  end

  def elem!(*args)
    es = elems(*args)
    raise 'multiple results' if es.size != 1
    es.first
  end

  def sorted_photographs
    @enabled_photographs.sort_by { |photograph| - score(photograph) }
  end

  def score photograph, *args
    jury_sum = elems(photograph, :jury, *args).map(&:mark).sum
    va = 0
    @stages.each do |stage|
      ve = elems(photograph, :viewer, stage, *args).map(&:mark)
      va += (ve.sum.to_f / ve.size).round if ve.size > 0
    end
    jury_sum + va
  end

  def photo photograph
    @photos.find{|photo| photo.user_id == photograph.id}
  end

  private
  def by_mark_type marks, arg
    marks.select {|mark| mark.mark_type_id == arg.id}
  end

  def by_user marks, arg
    if arg.in? (@juries + @viewers)
      ret = marks.select{|mark| mark.user_id == arg.id}
    elsif arg.in? @photographs
      ret = by_photograph marks, arg
    else
      return []
    end
    ret
  end

  def by_photograph marks, arg
    photo_ids = @photos.select do |photo|
      photo.user_id == arg.id
    end.map(&:id)
    marks.select {|mark| mark.photo_id.in? photo_ids}
  end

  def by_stage marks, arg
    photo_ids = @photos.select do |photo|
      photo.stage_id == arg.id
    end.map(&:id)
    marks.select {|mark| mark.photo_id.in? photo_ids}
  end

  def by_symbol marks, arg
    by_string marks, arg.to_s
  end

  def by_string marks, arg
    plur = arg.pluralize
    return [] unless plur.in? %w[juries viewers]
    user_ids = send(plur).map(&:id)
    marks.select{|mark| mark.user_id.in? user_ids}
  end

end
