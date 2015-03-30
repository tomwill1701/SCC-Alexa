# == Schema Information
#
# Table name: lgroups
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  sysplex     :boolean          default("false")
#  private     :boolean          default("false")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class LgroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
