# == Schema Information
#
# Table name: job_items
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  lgroup_id     :integer
#  cgroup_id     :integer
#  size          :string
#  chart_type    :string
#  chart_x       :string
#  chart_y       :string
#  chart_opt     :string
#  racf_password :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class JobItem < ActiveRecord::Base

  belongs_to :job

  belongs_to :cgroup
  belongs_to :lgroup

end
