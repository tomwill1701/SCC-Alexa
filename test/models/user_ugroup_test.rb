# == Schema Information
#
# Table name: user_ugroups
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ugroup_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class UserUgroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
