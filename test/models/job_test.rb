# == Schema Information
#
# Table name: jobs
#
#  id            :integer          not null, primary key
#  name          :string
#  jgroup        :string           default("Job")
#  jtype         :string
#  description   :text
#  menu          :string
#  cclass        :string
#  tags          :string
#  run_type      :string
#  keep_days     :integer
#  private       :boolean          default("false")
#  notify        :boolean          default("true")
#  notify_group  :boolean          default("true")
#  cache         :boolean          default("true")
#  debug         :boolean          default("true")
#  owner_id      :integer
#  ar_start      :datetime
#  ar_start_date :date
#  ar_start_time :time
#  ar_type       :string
#  ar_repeat     :string
#  ar_hour       :string
#  ar_wday       :string
#  ar_day        :string
#  ar_month      :string
#  ar_wdayt      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
