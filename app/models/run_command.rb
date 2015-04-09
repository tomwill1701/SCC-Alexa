# == Schema Information
#
# Table name: run_commands
#
#  id            :integer          not null, primary key
#  model         :text
#  rtext         :text
#  done          :boolean          default("false")
#  error         :boolean          default("false")
#  add_lpar      :boolean          default("false")
#  error_text    :string
#  status        :string
#  source        :string
#  data_acquired :datetime
#  cloud         :boolean          default("false")
#  compressed    :boolean          default("false")
#  merge_grid    :boolean          default("false")
#  run_id        :integer
#  lpar_id       :integer
#  job_item_id   :integer
#  command_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RunCommand < ActiveRecord::Base

  belongs_to :run
  belongs_to :lpar
  belongs_to :job_item
  belongs_to :command

  has_many :run_views, dependent: :destroy

  default_scope {order('id ASC')}

  attr_accessor :columns, :rows, :built

  #
  #  decompress the text
  #
  def rtext
    if self.compressed
      Zlib::Inflate.inflate(Base64.decode64(self[:rtext]))
    else
      self[:rtext]
    end
  end

  #
  #  compress the text
  #
  def rtext=(data)
    if data
      self.compressed = true
      super(Base64.encode64(Zlib::Deflate.deflate(data)))
    else
      super
    end
  end


  #
  #  build the columns and row information for a grid
  #
  def build

    self.columns = Array.new
    self.rows = Array.new

    if self.command.ctype == "Grid" && rtext && done && !error

      line = rtext.split("\r")

      #
      #  look for a schema line in the output and build a
      #  column object
      #
      cindex = 0
      line.each do |line|
        if line[0..10] == "MON10172-I "
          column = Column.new
          line = line[11..-1]
          column.name = line[0..16].strip
          column.hidden = true if column.name[0] == '#'
          column.offset = line[17..21].to_i - 1
          column.length = line[22..26].to_i
          column.type = line[27..31]
          column.key= line[32..40]
          column.ftype = line[41..49]
          column.index = cindex
          self.columns << column
          puts column.inspect
          cindex += 1
        end

        #
        #  look at each data line and create an array of values for the row
        #
        if line[0..10] == "MON10103-I "
          row = Array.new
          line = line[11..-1]
          columns.each_with_index do |col, i|
            str = line[col.offset..col.offset+col.length-1]
            if columns[i].ftype == "INT"
              str = str.to_i
            end
            row << str
          end
          self.rows << row
        end

      end

    end

    self.built = true

  end


end
