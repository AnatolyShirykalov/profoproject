# == Schema Information
#
# Table name: mark_types
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MarkType < ApplicationRecord
  validates :name, presence: true

  has_many :mark_type_stages, dependent: :destroy
  has_many :stages,           through: :mark_type_stages
  has_many :marks

  #accepts_nested_attributes_for :stages
  #accepts_nested_attributes_for :marks
  rails_admin do
    navigation_label 'Оценки'
    field :name
    field :description, :ckeditor
    field :stages
  end
end
