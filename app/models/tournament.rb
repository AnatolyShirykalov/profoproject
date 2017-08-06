# == Schema Information
#
# Table name: tournaments
#
#  id         :integer          not null, primary key
#  name       :string
#  slug       :string
#  sort       :integer
#  enabled    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tournament < ApplicationRecord
  include Enableable
  include Sortable
  has_many :stages, dependent: :destroy
  accepts_nested_attributes_for :stages
  %w[photographs juries].each do |roles|
    tr = :"tournament_#{roles}"
    has_many tr, -> {where(role: roles.singularize)},
      dependent: :destroy, class_name: 'TournamentUser'
    accepts_nested_attributes_for tr
    has_many :"#{roles}", through: tr, class_name: 'User', source: 'user'
  end
  rails_admin do
    field :name
    field :enabled, :toggle
    field :sort
    field :stages
    field :tournament_users
    list do
      exclude_fields :stages, :tournament_users
    end
  end
end
