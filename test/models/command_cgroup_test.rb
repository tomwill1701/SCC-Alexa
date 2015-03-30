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

require 'test_helper'

class CommandCgroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
