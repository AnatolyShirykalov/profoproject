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

  has_many                      :stages, dependent: :destroy
  accepts_nested_attributes_for :stages

  has_one :partiable,
          -> { where(enabled: true).where('deadline > ?', Time.now)},
          class_name: 'Stage'

  %w[photographs juries viewers].each do |roles|
    tr =                          :"tournament_#{roles}"
    has_many                      tr, -> {where(role: roles.singularize)},
                                  dependent: :destroy,
                                  class_name: 'TournamentUser'

    accepts_nested_attributes_for tr

    has_many                      roles.to_sym,
                                  through: tr,
                                  class_name: 'User',
                                  source: 'user'
  end

  has_many :tournament_enabled_photographs,
           -> {where role: 'photograph', enabled: true},
           class_name: 'TournamentUser', dependent: :destroy

  has_many :enabled_photographs, through: :tournament_enabled_photographs,
           source: 'user'

  rails_admin do
    field :name
    field :enabled, :toggle
    field :sort
    field :stages
    field :tournament_photographs
    field :tournament_juries
    list do
      exclude_fields :stages, :tournament_phorographs, :tournament_juries
    end
  end
end
