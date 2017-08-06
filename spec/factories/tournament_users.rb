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

FactoryGirl.define do
  factory :tournament_user do
    tournament nil
    user nil
    role "MyString"
    enabled false
    sort 1
  end
end
