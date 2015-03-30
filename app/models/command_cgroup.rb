# == Schema Information
#
# Table name: command_cgroups
#
#  id         :integer          not null, primary key
#  command_id :integer
#  cgroup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CommandCgroup < ActiveRecord::Base

  belongs_to :command, required: true
  belongs_to :cgroup, required: true

  validates :command_id, :cgroup_id, presence: true
  validates :cgroup_id, :uniqueness => {:scope => :command_id}

end
