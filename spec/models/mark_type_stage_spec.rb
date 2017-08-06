# == Schema Information
#
# Table name: mark_type_stages
#
#  id           :integer          not null, primary key
#  stage_id     :integer
#  mark_type_id :integer
#  enabled      :boolean          default(FALSE), not null
#  sort         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe MarkTypeStage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
