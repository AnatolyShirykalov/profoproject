# == Schema Information
#
# Table name: stages
#
#  id            :integer          not null, primary key
#  name          :string
#  content       :text
#  enabled       :boolean          default(FALSE), not null
#  sort          :integer
#  tournament_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Stage < ApplicationRecord
  include Enableable
  include Sortable
  belongs_to :tournament
  has_many :photos, -> {where(target: 'stage')}, dependent: :destroy
  has_many :backstage_photos, -> {where(target: 'backstage')},
    class_name: 'Photo', dependent: :destroy
  has_many :mark_type_stages, dependent: :destroy
  has_many :mark_types, through: :mark_type_stages
  %i[mark_types photos backstage_photos].each do |key|
    accepts_nested_attributes_for key
  end
  rails_admin do
    field :name
    field :tournament
    field :content, :ckeditor
    field :enabled, :toggle
    field :sort
    field :mark_types
    field :photos
    field :backstage_photos
    list do
      exclude_fields :photos, :backstage_photos, :mark_types
    end
  end
end
