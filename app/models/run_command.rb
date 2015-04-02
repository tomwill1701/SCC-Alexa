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
#  cache_time    :integer
#  error_text    :string
#  status        :string
#  source        :string
#  data_acquired :datetime
#  run_id        :integer
#  lpar_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RunCommand < ActiveRecord::Base

  belongs_to :run
  belongs_to :lpar

  has_many :run_views, dependent: :destroy

  attr_accessor :columns, :rows


  #
  #  build the columns and row information for a grid
  #
  def build

    if self.command.ctype == "Grid" && rtext && done && !error

      line = rtext.split("\r")
      self.columns = Array.new
      self.rows = Array.new

      #
      #  look for a schema line in the output and build a
      #  column object
      #
      line.each do |line|
        if line[0..10] == "MON10172-I "
          column = Column.new
          line = line[11..-1]
          column.name = line[0..16]
          column.hidden = true if column.name[0] == '#'
          column.offset = line[17..21].to_i - 1
          column.length = line[22..26].to_i
          column.type = line[27..31]
          column.key= line[32..40]
          column.ftype = line[41..49]
          self.columns << column
          puts column.inspect
        end

        #
        #  look at each data line and create an array of values for the row
        #
        if line[0..10] == "MON10103-I "
          row = Array.new
          line = line[11..-1]
          columns.each do |col|
            row << line[col.offset..col.offset+col.length-1]
          end
          self.rows << row
        end

      end

    end
  end


end
