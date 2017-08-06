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

class Mark < ApplicationRecord
  belongs_to :mark_type
  belongs_to :photo
  belongs_to :user
  validates :mark_type_id, :photo_id, :user_id,
            :mark, :content, presence: true
  accepts_nested_attributes_for :mark_type
  accepts_nested_attributes_for :photo
  accepts_nested_attributes_for :user

  rails_admin do
    field :mark_type
    field :user
    field :photo
    field :mark
    field :content
  end

  def name
    mark
  end

end
