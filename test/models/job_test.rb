# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  name             :string
#  jgroup           :string           default("Job")
#  jtype            :string
#  description      :text
#  menu             :string
#  cclass           :string
#  tags             :string
#  run_type         :string
#  keep_days        :integer
#  private          :boolean          default(FALSE)
#  notify           :boolean          default(TRUE)
#  notify_group     :boolean          default(TRUE)
#  cache            :boolean          default(TRUE)
#  debug            :boolean          default(TRUE)
#  owner_id         :integer
#  ar_start         :datetime
#  ar_start_date    :date
#  ar_start_time    :time
#  ar_type          :string
#  ar_repeat        :string
#  ar_hour          :string
#  ar_wday          :string
#  ar_day           :string
#  ar_month         :string
#  ar_wdayt         :string
#  ar_file          :string
#  ar_active        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  ar_file_modified :string
#

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
