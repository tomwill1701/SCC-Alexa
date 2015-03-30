# == Schema Information
#
# Table name: lpar_lgroups
#
#  id         :integer          not null, primary key
#  lpar_id    :integer
#  lgroup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LparLgroup < ActiveRecord::Base

  belongs_to :lpar, required: true
  belongs_to :lgroup, required: true

  validates :lgroup_id, :uniqueness => {:scope => :lpar_id}

end
