# == Schema Information
#
# Table name: tournament_users
#
#  id            :integer          not null, primary key
#  tournament_id :integer
#  user_id       :integer
#  role          :string
#  enabled       :boolean          default(FALSE), not null
#  sort          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TournamentUser < ApplicationRecord
  extend Enumerize
  include Enableable
  include Sortable
  belongs_to :tournament
  belongs_to :user
  enumerize :role, in: %w[photograph jury viewer]

  def enable!
    self.enabled = true
    save!
  end

  rails_admin do
    field :tournament
    field :user
    field :role
    field :enabled, :toggle
    field :sort
  end
end
