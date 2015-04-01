# == Schema Information
#
# Table name: jobs
#
#  id           :integer          not null, primary key
#  name         :string
#  jtype        :string
#  description  :text
#  menu         :string
#  cclass       :string
#  tags         :string
#  when         :string
#  when_time    :string
#  run_type     :string
#  keep_days    :integer
#  private      :boolean          default("false")
#  notify       :boolean          default("true")
#  notify_group :boolean          default("true")
#  cache        :boolean          default("true")
#  owner_id     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
