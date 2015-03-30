# == Schema Information
#
# Table name: lpar_restricts
#
#  id         :integer          not null, primary key
#  lgroup_id  :integer
#  ugroup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LparRestrict < ActiveRecord::Base

  belongs_to :lgroup, required: true
  belongs_to :ugroup, required: true

end
