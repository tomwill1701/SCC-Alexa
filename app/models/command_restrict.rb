# == Schema Information
#
# Table name: command_restricts
#
#  id         :integer          not null, primary key
#  cgroup_id  :integer
#  ugroup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CommandRestrict < ActiveRecord::Base

  belongs_to :cgroup, required: true
  belongs_to :ugroup, required: true

end
