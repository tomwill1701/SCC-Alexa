# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  name            :string
#  department      :string
#  phone           :string
#  email           :string
#  racf_userid     :string
#  racf_group      :string
#  racf_password   :string
#  admin           :boolean          default("false")
#  password_digest :string
#  last_login      :datetime
#  login_count     :integer          default("0")
#  background      :string
#  notify          :string
#  cache           :string
#  prompt_ok       :string
#  prompt_cancel   :string
#  prompt_values   :string
#  prompt_fields   :string
#  lpar_id         :integer
#  command_id      :integer
#  job_id          :integer
#  ugroup_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
