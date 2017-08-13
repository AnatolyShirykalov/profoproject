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

  %i[mark_types].each {|key| accepts_nested_attributes_for key}


  def photo_debtors
    sql = '(SELECT COUNT(photos.*) FROM photos' +
          ' WHERE photos.user_id = users.id AND photos.target = ?' +
          ' AND stage_id = ?) < ?'
    tournament.enabled_photographs.where sql, 'stage', id, 1
  end

  rails_admin do
    field :name
    field :tournament
    field :deadline
    field :content, :ckeditor
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
    @mem_jury_ids    = tournament.juries.pluck(:id)
    @mem_viewer_ids  = tournament.viewers.pluck(:id)
    @mem_photos      = photos.all.to_a
    @mem_mark_types  = mark_types.all.to_a
    @mem_marks       = Mark.where(user_id: @mem_jury_ids + @mem_viewer_ids,
                                  photo_id: @mem_photos.map(&:id)).to_a
  end

  def results
    memorize
    puts "memorized!"
    @mem_marks.group_by(&:photo_id).map(&results_by_photo).map do |ph|
      jt = ph[:marks][:juries].map(&:mark).sum
      vt = results_total(ph[:marks][:viewers])
      ph.merge total: jt + vt
    end.map do |ph|
      ph.merge results_by_type(ph)
    end
  end

  private
  def results_by_photo
    Proc.new do |pid, ms|
      {
        photo_id: pid,
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
end
