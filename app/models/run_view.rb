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

  #
  #  build column names for grid
  #
  def columnNames
    rc = self.run_command
    rc.build unless rc.built
    list = rc.columns.map { |c| c.name}
    list.join(",")
  end

  #
  #  build column types for grid
  #
  def columnTypes
    rc = self.run_command
    rc.build unless rc.built
    list = rc.columns.map { |c| c.type}
    list.join(",")
  end

  #
  #  build column widths for grid
  #
  def columnWidths
    return ""
  end

  #
  #  build column sorting for grid
  #
  def columnSorting
    rc = self.run_command
    rc.build unless rc.built
    list = rc.columns.map { |c| c.grid_ftype}
    str = list.join(",")
    str.gsub!('STRING','str')
    str.gsub!('INT','int')
    str.gsub!('DATE','date')
    return str
  end

  #
  #  build column align for grid
  #
  def columnAlign
    str = columnSorting
    str.gsub!('str','left')
    str.gsub!('int','right')
    str.gsub!('date','left')
    return str
  end

  #
  #  return data rows
  #
  def rows
    self.run_command.rows
  end

end
