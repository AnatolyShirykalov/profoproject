# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  name               :string
#  slug               :string
#  description        :string
#  target             :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  stage_id           :integer
#  user_id            :integer
#  enabled            :boolean          default(FALSE), not null
#  sort               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Photo < ApplicationRecord
  attr_accessor :src

  extend Enumerize
  include Enableable
  include Sortable

  belongs_to :user
  belongs_to :stage

  has_many                      :marks, dependent: :destroy
  accepts_nested_attributes_for :marks

  has_attached_file                 :photo
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  has_attached_file                 :photo1
  validates_attachment_content_type :photo1, content_type: /\Aimage\/.*\Z/
  has_attached_file                 :photo2
  validates_attachment_content_type :photo2, content_type: /\Aimage\/.*\Z/

  enumerize :target, in: %w[stage backstage]

  def total_mark_by roles, mark_type = nil
    qmt = mark_type ? {mark_type: mark_type} : nil
    method = (roles == 'viewers') ? 'average' : 'sum'
    marks.where(user_id: stage.tournament.send(roles).pluck(:id)).
          where(qmt).send(method, :mark).round
  end

  def total_mark
    %i[juries viewers].map{|r| total_mark_by r}.sum
  end

  def has_all_marks? user
    stage.mark_types.count == marks.where(user: user).count
  end

  scope :unmarked_by, lambda { |user, stage|
    where("(SELECT COUNT(*) FROM marks WHERE marks.user_id = ? AND marks.photo_id = photos.id) < ?", user.id, stage.mark_types.count)
  }

  rails_admin do
    navigation_label 'Фотографии'
    field :name
    field :photo
    field :photo1
    field :photo2
    field :stage
    field :target
    field :marks
    edit do
      exclude_fields :marks
    end
    create do
      exclude_fields :marks
    end
  end
end
