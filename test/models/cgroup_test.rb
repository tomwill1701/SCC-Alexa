# == Schema Information
#
# Table name: cgroups
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  private     :boolean          default("false")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class CgroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
