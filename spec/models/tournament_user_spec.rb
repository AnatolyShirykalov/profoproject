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

require 'rails_helper'

RSpec.describe TournamentUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
