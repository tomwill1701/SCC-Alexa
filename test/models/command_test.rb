# == Schema Information
#
# Table name: commands
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  ctype       :string
#  model       :text
#  file        :string
#  prompts     :string
#  variables   :string
#  source      :string
#  member      :string
#  keys        :string
#  size        :string
#  chart_type  :string
#  chart_x     :string
#  chart_y     :string
#  chart_opt   :text
#  cclass      :string
#  tags        :string
#  preload     :string
#  cache_time  :integer          default(0)
#  rscript     :text
#  vscript     :text
#  hide        :boolean          default(FALSE)
#  data_type   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class CommandTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
