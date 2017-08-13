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
  has_many :photos, -> {where(target: 'stage')}, dependent: :destroy
  has_many :backstage_photos, -> {where(target: 'backstage')},
    class_name: 'Photo', dependent: :destroy
  has_many :mark_type_stages, dependent: :destroy
  has_many :mark_types, through: :mark_type_stages
  %i[mark_types].each do |key|
    accepts_nested_attributes_for key
  end
  has_many :marks, through: :photos
  friendly_id :name, use: :slugged


  def photo_debtors
    sql = '(SELECT COUNT(photos.*) FROM photos WHERE photos.user_id = users.id AND photos.target = ? AND stage_id = ?) < ?'
    tournament.enabled_photographs.where(sql, 'stage', id, 1)
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

  def current?
    Stage.current.id == id
  end

  def markable? current_user
    c1 = tournament.juries.find_by(id: current_user.id)
  end

  def has_all_marks?
    tournament.juries.count * mark_types.count == marks.count
  end

  def all_photos_loaded?
    tournament.enabled_photographs.count == photos.count
  end

end
