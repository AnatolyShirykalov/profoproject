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

FactoryGirl.define do
  factory :mark_type do
    name "MyString"
    description "MyString"
  end
end
