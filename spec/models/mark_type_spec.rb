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

require 'rails_helper'

RSpec.describe MarkType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
