# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  name               :string
#  slug               :string
#  description        :string
#  target             :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  stage_id           :integer
#  user_id            :integer
#  enabled            :boolean          default(FALSE), not null
#  sort               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :photo do
    name "MyString"
    slug "MyString"
    desciptions "MyString"
    photo ""
    user nil
    enabled false
    sort 1
  end
end
