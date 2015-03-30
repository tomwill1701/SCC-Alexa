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

require 'test_helper'

class LparRestrictTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
