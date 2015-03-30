# == Schema Information
#
# Table name: jobitems
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  lgroup_id  :integer
#  cgroup_id  :integer
#  staged     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class JobitemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
