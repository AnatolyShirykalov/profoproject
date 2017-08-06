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

FactoryGirl.define do
  factory :tournament do
    name "MyString"
    slug "MyString"
    sort 1
    enabled false
  end
end
