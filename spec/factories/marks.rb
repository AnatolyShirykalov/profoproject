# == Schema Information
#
# Table name: marks
#
#  id                  :integer          not null, primary key
#  mark_type_id        :integer
#  photo_id            :integer
#  user_id             :integer
#  mark                :integer          default(0), not null
#  content             :text             default(""), not null
#  image1_file_name    :string
#  image1_content_type :string
#  image1_file_size    :integer
#  image1_updated_at   :datetime
#  image2_file_name    :string
#  image2_content_type :string
#  image2_file_size    :integer
#  image2_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
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
