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
  # get size of grid
  #
  def size
    rc = self.run_command
    rc.build unless rc.built
    size = self.command.size
    size = self.job_item.size if self.job_item.size
    return size.split(';')
  end


  #
  #  build column names for grid
  #
  def columnNames
    rc = self.run_command
    list = rc.columns.map { |c| c.name unless c.hidden}
    list.compact.join(",")
  end

  #
  #  build column types for grid
  #
  def columnTypes
    rc = self.run_command
    list = rc.columns.map { |c| c.type unless c.hidden}
    list.compact.join(",")
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
    list = rc.columns.map { |c| c.grid_ftype unless c.hidden}
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
    rows = self.run_command.rows.dup
    self.run_command.columns.to_enum.with_index.reverse_each do |c, i|
      if c.hidden
        rows.each do |r|
          r.delete_at(i)
        end
      end
    end
    return rows
  end

  #
  #  return row colors
  #
  def rowColors
    color = self.run_command.columns.find {|c| c.name == '#COLOR' }
    if !color
      return ""
    else
      return ""
    end
  end


  #
  #  build google chart
  #
  def chart
    rc = self.run_command
    ji = self.job_item
    command = self.command
    rc.build unless rc.built

    #
    #  get chart type and x/y field names
    #
    ct = command.chart_type
    fn = command.chart_x + "," + command.chart_y
    if ji.chart_type.length > 0
      ct = ji.chart_type
      fn = ji.chart_x + "," + ji.chart_y
    end

    #
    #  build columns
    #
    data_table = GoogleVisualr::DataTable.new
    fna = fn.downcase.split(',')
    col = rc.columns.select{|c| fna.include?(c.name.downcase) }
    col.each do |column|
      type = column.ftype
      if type
        type.gsub!('STRING','string')
        type.gsub!('INT','number')
        type.gsub!('DATE','date')
        type.gsub!('BOOL','boolean')
      else
        type = 'string'
      end
      data_table.new_column(type, column.name )
    end

    #
    #  build data rows
    #
    rc.rows.each do |row|
      crow = Array.new
      col.each do |column|
        crow << row[column.index]
      end
      data_table.add_row(crow)
    end

    #
    #  build chart
    #
    option = { width: size[0], height: size[1], title: command.name }
    case command.chart_type
    when "Pie"
      GoogleVisualr::Interactive::PieChart.new(data_table, option)
    when "Bar"
      GoogleVisualr::Interactive::BarChart.new(data_table, option)
    when "Line"
      GoogleVisualr::Interactive::LineChart.new(data_table, option)
    when "Gauge"
      GoogleVisualr::Interactive::Guage.new(data_table, option)
    when "Area"
      GoogleVisualr::Interactive::AreaChart.new(data_table, option)
    when "Candle"
      GoogleVisualr::Interactive::CandleChart.new(data_table, option)
    when "Bubble"
      GoogleVisualr::Interactive::BubbleChart.new(data_table, option)
    when "Column"
      GoogleVisualr::Interactive::ColumnChart.new(data_table, option)
    when "Combo"
      GoogleVisualr::Interactive::ComboChart.new(data_table, option)
    when "Scatter"
      GoogleVisualr::Interactive::ScatterChart.new(data_table, option)
    when "Spark"
      GoogleVisualr::Interactive::SparkChart.new(data_table, option)
    end

  end

end
