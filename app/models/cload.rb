# == Schema Information
#
# Table name: cloads
#
#  id         :integer          not null, primary key
#  dsname     :string
#  volser     :string
#  lpar_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cload < ActiveRecord::Base

  has_many :cload_items, dependent: :destroy
  belongs_to :lpar, required: true

  validates :dsname, presence: true
  validates :dsname, uniqueness: true


  #
  #  parse the passed string and build a cload_item for each
  #  command
  #
  def self.load(cload, string)

    #
    #  build an array of hashes for each cload item we need to create
    #
    remap = {"desc" => "description", "type" => "ctype", "cmd" => "model",
      "tag" => "tags", "class" => "cclass"}
      cmd = Cload.s_to_hash(string, remap)

      #
      #  go through each command and see if it already exists in the
      #  command table
      #
      puts cmd.inspect
      cmd.each do |cmdi|
        puts cmdi.inspect
        status = "New"
        if Command.find_by(name: cmdi["name"])
          status = "Exists"
        end
        c = CloadItem.find_by(name: cmdi["name"])
        if c
          c.update(cmdi.merge(cload: cload, status: status, source: cload.dsname))
        else
          c = CloadItem.create(cmdi.merge(cload: cload, status: status, source: cload.dsname))
        end

      end

    end

    def self.s_to_hash(string, remap)

      #
      #  take any line that starts with "*$ " and break it down into key
      #  value
      #
      #  any line with no key "*$  = value" goes with the previous key
      #

      line = string.split( /\r?\n/ )
      line << "*$ name=x"  # make sure we hit a null at the end

      args = {}
      cmds = []
      last = ""

      line.each do |line|
        if line[0..2] == "*$ "
          s = line[3..71].split(/= */,2)
          key = s[0].downcase.strip
          value = s[1].strip.chomp if s[1]

          #
          #  see if this keyword need to be remaped into a different table
          #  field name
          #
          if remap[key]
            key = remap[key]
          end

          #
          #  see if this is the end of a block of key/values
          #
          if (key == "member") & args["name"]
            cmds << args.dup
            args = {}
          end
          if (key == "name") & args["name"]
            cmds << args.dup
            args.delete("name")
          end

          #
          #  see if this keyword is blank.  then it goes with the previous keyword
          #
          if key != ""
            args[key] = value
            last = key
          else
            args[last] = args[last] + " " + value if args[last]
          end

        end

      end

      return cmds

    end


  end
