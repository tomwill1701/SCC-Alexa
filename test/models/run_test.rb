# == Schema Information
#
# Table name: runs
#
#  id         :integer          not null, primary key
#  background :boolean          default("false")
#  error      :boolean          default("false")
#  done       :boolean          default("false")
#  status     :string
#  error_text :string
#  log        :text
#  start      :datetime
#  end        :datetime
#  viewed_at  :datetime
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
