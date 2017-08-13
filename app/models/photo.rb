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

  rails_admin do
    field :name
    field :photo
    field :stage
    field :target
    field :marks
  end
end
