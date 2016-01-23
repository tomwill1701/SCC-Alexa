# == Schema Information
#
# Table name: run_views
#
#  id             :integer          not null, primary key
#  name           :string
#  file           :string
#  file_type      :string
#  hide           :boolean          default("false")
#  run_command_id :integer
#  run_id         :integer
#  job_item_id    :integer
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
