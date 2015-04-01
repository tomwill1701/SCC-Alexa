# == Schema Information
#
# Table name: runs
#
#  id         :integer          not null, primary key
#  background :boolean          default("true")
#  cache      :boolean          default("true")
#  error      :boolean          default("false")
#  done       :boolean          default("false")
#  notify     :boolean          default("false")
#  status     :string
#  error_text :string
#  log        :text
#  total_data :integer
#  start      :datetime
#  end        :datetime
#  viewed     :datetime
#  delete_at  :datetime
#  ugroup_id  :integer
#  job_id     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class RunTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
