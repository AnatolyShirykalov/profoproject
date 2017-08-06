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

class MarkTypeStage < ApplicationRecord
  include Enableable
  include Sortable
  belongs_to :stage
  belongs_to :mark_type
  rails_admin do
    hide
  end
end
