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

FactoryGirl.define do
  factory :mark_type_stage do
    stage nil
    mark_type nil
    enabled false
    sort 1
  end
end
