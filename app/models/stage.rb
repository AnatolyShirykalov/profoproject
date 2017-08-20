# == Schema Information
#
# Table name: stages
#
#  id            :integer          not null, primary key
#  name          :string
#  slug          :string
#  content       :text
#  enabled       :boolean          default(FALSE), not null
#  sort          :integer
#  tournament_id :integer
#  deadline      :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Stage < ApplicationRecord
  include Enableable
  include Sortable
  extend FriendlyId

  belongs_to :tournament

  has_many :photos,             -> {where target: 'stage'},
            dependent: :destroy

  has_many :backstage_photos,   -> {where target: 'backstage'},
           class_name: 'Photo', dependent: :destroy

  has_many :mark_type_stages,   dependent: :destroy
  has_many :mark_types,         through: :mark_type_stages
  has_many :marks,              through: :photos

  friendly_id :name, use: :slugged

  #%i[mark_types].each {|key| accepts_nested_attributes_for key}


  def photo_debtors
    sql = '(SELECT COUNT(photos.*) FROM photos' +
          ' WHERE photos.user_id = users.id AND photos.target = ?' +
          ' AND stage_id = ?) < ?'
    tournament.enabled_photographs.where sql, 'stage', id, 1
  end

  rails_admin do
    navigation_label 'Рубежи'
    field :name
    field :tournament
    field :deadline
    #field :content, :ckeditor
    field :enabled, :toggle
    field :sort
    field :mark_types
    #field :photos
    #field :backstage_photos
    list do
      exclude_fields :photos, :backstage_photos, :mark_types
    end
  end

  def self.current
    enabled.order(:deadline).last
  end

  scope :closed, -> {
    enabled.where('deadline < ?', self.current.deadline).order(:deadline)
  }

  def current?
    Stage.current.id == id
  end

  def markable? current_user
    TournamentUser.find_by user: current_user, tournament: tournament,
                           role: %w[jury viewer]
  end

  def has_all_marks?
    tournament.juries.count * mark_types.count == marks.count
  end

  def all_photos_loaded?
    tournament.enabled_photographs.count == photos.count
  end

  def memorize
    return if @mem_jury_ids
    @mem_photographs = tournament.photographs.all.to_a
    @mem_juries      = tournament.juries.all.to_a
    @mem_jury_ids    = @mem_juries.map(&:id)
    @mem_viewers     = tournament.viewers.all.to_a
    @mem_viewer_ids  = @mem_viewers.map(&:id)
    @mem_photos      = photos.all.to_a
    @mem_mark_types  = mark_types.all.to_a
    @mem_marks       = Mark.where(user_id: @mem_jury_ids + @mem_viewer_ids,
                                  photo_id: @mem_photos.map(&:id)).
                            preload(:user).to_a
  end

  def results
    return @rts if @rts
    memorize
    puts "memorized!"
    @rts = @mem_marks.group_by(&:photo_id).map(&results_by_photo).map do |ph|
      jt = ph[:marks][:juries].map(&:mark).sum
      vt = results_total(ph[:marks][:viewers])
      ph.merge total: jt + vt
    end.map do |ph|
      ph.merge results_by_type(ph)
    end.map do |ph|
      ph.merge results_by_user(ph)
    end
  end

  def to_rows
    results.sort{|r| -r[:total]}.map.with_index do |result, i|
      a = [i + 1, result[:user].name, result[:total]] +
      @mem_mark_types.map do |mark_type|
        %i[juries viewers].map {|role| result[role][mark_type.name]}
      end.inject(:+)
      a
    end
  end

  def to_rows!
    @rts = nil
    instance_variables.select{|v| v.to_s.match(/\A@mem/)}.each do |v|
      instance_variable_set v, nil
    end
    to_rows
  end

  def row_header
    %w[# Участник Всего] + mark_types.map do |mark_type|
      ['жюри', 'совет зрителей'].map {|name| "#{mark_type.name} (#{name})"}
    end.inject(:+)
  end

  private
  def results_by_photo
    Proc.new do |pid, ms|
      {
        photo_id: pid,
        photo: @mem_photos.find{|ph| ph.id == pid},
        user: @mem_photographs.find do |u|
          u.id == @mem_photos.find{|ph| ph.id == pid}.user_id
        end,
        marks: ms.group_by do |m|
          m.user_id.in?(@mem_jury_ids) ? :juries : :viewers
        end
      }
    end
  end

  def results_total ms, r = 'juries'
    t = ms.map(&:mark).sum
    return t if r.to_s == 'juries'
    (t.to_f / ms.size.to_f).round
  end

  def results_by_type ph
    by_type = {}
    %i[juries viewers].each do |r|
      by_type[r] = begin
        ret = {}
        ph[:marks][r].group_by(&:mark_type_id).each do |mid, ms|
          mt_name = @mem_mark_types.find{|mt| mt.id == mid}.name
          ret[mt_name] = results_total(ms, r)
        end
        ret
      end
    end
    by_type
  end

  def results_by_user ph
    {by_user: ph[:marks][:juries].group_by(&:user_id).map do |uid, ms|
      {
        user: @mem_juries.find {|u| u.id == uid},
        marks: ms.group_by(&:mark_type_id).map do |mt_id, ms_t|
          {
            type: @mem_mark_types.find{|mt| mt.id == mt_id},
            mark: ms_t.first,
          }
        end,
      }
    end}
  end
end
