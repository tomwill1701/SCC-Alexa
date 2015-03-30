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

require 'test_helper'

class CommandRestrictTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
