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

require 'rails_helper'

RSpec.describe Stage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
