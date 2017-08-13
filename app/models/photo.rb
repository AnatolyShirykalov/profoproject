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
  has_many :marks, dependent: :destroy
  has_attached_file :photo
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  enumerize :target, in: %w[stage backstage]
  accepts_nested_attributes_for :marks

  rails_admin do
    field :name
    field :photo
    field :stage
    field :target
    field :marks
  end
end
