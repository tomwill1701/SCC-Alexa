# == Schema Information
#
# Table name: run_views
#
#  id             :integer          not null, primary key
#  type           :string
#  file           :string
#  file_type      :string
#  run_command_id :integer
#  command_id     :integer
#  job_item_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class RunView < ActiveRecord::Base

  belongs_to :run_command
  belongs_to :command
  belongs_to :job_item

end
