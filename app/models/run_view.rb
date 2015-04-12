# == Schema Information
#
# Table name: run_views
#
#  id             :integer          not null, primary key
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

  default_scope {order('id ASC')}

  attr_accessor :vtype, :chart_type, :x_fields, :y_fields,
                :options, :size, :title

  mount_uploader :file, ExtUploader

  #
  #  get attributes of this view
  #
  def attr

    #
    #  check for external generated view
    #
    if file.present?
      self.vtype = 'file'
      return
    end

    #
    #  get command and job_item
    #
    rc = self.run_command
    cmd = self.command
    ji = self.job_item
    rc.build unless rc.built

    #
    #  set type of view
    #
    if cmd.chart_type.present? || ji.chart_type.present?
      self.vtype = 'chart'
    elsif cmd.ctype == 'DIFCmd' || cmd.ctype == 'MVSCmd'
      self.vtype = 'text'
    elsif cmd.ctype == 'Grid'
      self.vtype = 'grid'
    end

    #
    #  set chart options
    #
    self.x_fields = set(cmd.chart_x, ji.chart_x)
    self.y_fields = set(cmd.chart_y, ji.chart_y)
    self.chart_type = set(cmd.chart_type, ji.chart_type)

    self.options = set(cmd.chart_opt, ji.chart_opt)

    self.size = set(cmd.size, ji.size)
    self.size = "" if !size
    self.size = size.split(';')

    self.title = set(cmd.name, ji.chart_title)

  end

  #
  #  set field from first value or second value if second value exists
  #
  def set(fv, sv)
    if sv.present?
      return sv
    else
      return fv
    end

  end

  #
  #  build column names for grid
  #
  def columnNames
    rc = run_command
    list = rc.columns.map { |c| c.name unless c.hidden }
    list.compact.join(",")
  end

  #
  #  build column types for grid
  #
  def columnTypes
    rc = run_command
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
    rc = run_command
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
    rows = run_command.rows.dup
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
    color = run_command.columns.find {|c| c.name == '#COLOR' }
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

    #
    #  get chart type and x/y field names
    #
    return unless x_fields && y_fields
    rc = run_command
    fn = x_fields + "," + y_fields

    #
    #  build columns
    #
    data_table = GoogleVisualr::DataTable.new
    fna = fn.downcase.split(',')
    puts "Cname", fna.inspect
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
      puts "Col:", type, title
      data_table.new_column(type, title )
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
      puts "Data:", crow.inspect
    end

    #
    #  build chart
    #
    option = { width: size[0], height: size[1], title: title }
    case chart_type
    when "Pie"
      GoogleVisualr::Interactive::PieChart.new(data_table, option)
    when "Bar"
      GoogleVisualr::Interactive::BarChart.new(data_table, option)
    when "Line"
      GoogleVisualr::Interactive::LineChart.new(data_table, option)
    when "Gauge"
      GoogleVisualr::Interactive::Gauge.new(data_table, option)
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

  #
  #  return text form difcmd and mvscmd
  #
  def text
    if run_command.rtext.blank?
      return ""
    else
      return run_command.rtext
    end
  end

end
