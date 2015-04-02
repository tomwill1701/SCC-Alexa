# == Schema Information
#
# Table name: run_views
#
#  id             :integer          not null, primary key
#  type           :string
#  file           :string
#  file_type      :string
#  run_command_id :integer
#  run_id         :integer
#  job_item_id    :integer
#  command_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class RunView < ActiveRecord::Base

  belongs_to :run
  belongs_to :run_command
  belongs_to :job_item
  belongs_to :command

  def columnNames
    rc = self.run_command
    list = rc.columns.map { |c| c.name}
    list.join(",")
  end

  def columnTypes
    rc = self.run_command
    list = rc.columns.map { |c| c.type}
    list.join(",")
  end

  def columnWidths
    return ""
  end

  def rows
    self.run_command.rows
  end

end
