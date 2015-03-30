# == Schema Information
#
# Table name: lpars
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  ip          :string
#  port        :integer
#  location    :string
#  zos_release :string
#  subsystems  :string
#  monproc     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class LparTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
