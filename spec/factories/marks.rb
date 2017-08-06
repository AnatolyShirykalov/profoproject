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

FactoryGirl.define do
  factory :mark do
    mark_type nil
    stage_user_photo nil
    user nil
    mark 1
    content "MyString"
  end
end
