# == Schema Information
#
# Table name: commands
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  ctype       :integer
#  model       :text
#  prompts     :string
#  source      :string
#  member      :string
#  keys        :string
#  chart_type  :integer
#  chart_x     :string
#  chart_y     :string
#  chart_opt   :text
#  cclass      :string
#  tags        :string
#  preload     :string
#  cache_time  :integer
#  rscript     :text
#  vscript     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class CommandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
