# == Schema Information
#
# Table name: marks
#
#  id           :integer          not null, primary key
#  mark_type_id :integer
#  photo_id     :integer
#  user_id      :integer
#  mark         :integer          not null
#  content      :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Mark, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
