# == Schema Information
#
# Table name: ugroups
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  racf_group  :string
#  private     :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class UgroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
