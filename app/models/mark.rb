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

class Mark < ApplicationRecord
  belongs_to :mark_type
  belongs_to :photo
  belongs_to :user
  validates :mark_type_id, :photo_id, :user_id, presence: true
  #accepts_nested_attributes_for :mark_type
  #accepts_nested_attributes_for :photo
  #accepts_nested_attributes_for :user

  has_attached_file                 :image1
  validates_attachment_content_type :image1, content_type: /\Aimage\/.*\Z/

  has_attached_file                 :image2
  validates_attachment_content_type :image2, content_type: /\Aimage\/.*\Z/


  rails_admin do
    navigation_label 'Оценки'
    edit do
      field :mark_type do
        read_only true
      end
      field :photo do
        read_only true
        pretty_value do
          "<a href='#{value.photo.url}' target='_blank'><img style='max-height: 150px' src='#{value.photo.url}'/></a>".html_safe
        end
      end
      field :mark do
        visible do
          bindings[:object].mark_type.name != 'Комментарий'
        end
      end
      field :content do
        visible do
          bindings[:object].mark_type.name == 'Комментарий'
        end
      end
      field :image1 do
        visible do
          bindings[:object].mark_type.name == 'Комментарий'
        end
      end
      field :image2 do
        visible do
          bindings[:object].mark_type.name == 'Комментарий'
        end
      end
    end
  end

  def name
    mark
  end

end
