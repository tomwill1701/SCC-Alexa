# == Schema Information
#
# Table name: run_views
#
#  id             :integer          not null, primary key
#  type           :string
#  file           :string
#  file_type      :string
#  size           :string
#  chart_type     :string
#  chart_x        :string
#  chart_y        :string
#  chart_opt      :string
#  run_command_id :integer
#  command_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class RunViewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
