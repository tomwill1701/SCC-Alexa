# == Schema Information
#
# Table name: runs
#
#  id          :integer          not null, primary key
#  background  :boolean          default("true")
#  cache       :boolean          default("true")
#  error       :boolean          default("false")
#  done        :boolean          default("false")
#  notify      :boolean          default("false")
#  name        :string
#  status      :string
#  error_text  :string
#  log         :text
#  total_data  :integer
#  start       :datetime
#  end         :datetime
#  viewed      :datetime
#  delete_at   :datetime
#  delete_when :string
#  note        :string
#  auto_run    :boolean          default("false")
#  ugroup_id   :integer
#  job_id      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Run < ActiveRecord::Base

  attr_accessor :select, :attachments
  attr_accessor :keep_days
  attr_accessor :xmlfile

  belongs_to :ugroup
  belongs_to :job
  belongs_to :user

  has_many :run_commands, dependent: :destroy
  has_many :run_views, through: :run_commands
  has_many :notices, dependent: :destroy

  scope :with_background, -> { where("background = true")  }
  scope :with_error, -> { where("error = true")  }
  scope :with_done, -> { where("done = true")  }
  scope :with_nv, -> { where("viewed IS NULL")  }

  #
  #  ransack filters
  #
  def self.ransackable_scopes(auth_object = nil)
    [:with_background, :with_error, :with_done, :with_nv, :name]
  end

  #
  #  keep days run attribute
  #
  def keep_days=(days)
    self.delete_at = Date.today + days.to_i
  end


  #
  #  add log message to log array
  #
  def <<(string)
    self.log ||= String.new
    self.log += "#{Time.now}: #{string}" + "\r"
  end

  #
  #  build status message
  #
  def dstatus
    status = ""
    status += "Background " if self.background
    status += "Done " if self.done
    status += "Error " if self.error
    return status
  end


  #
  #  take the passed job and build a new run
  #  this will consist of one or more run_command entries (data acquisition)
  #  and one ore more run_views attached to the run_command to show text/grid/charts
  #
  def build(job, user)

    #
    #  find the current job and build a new run
    #
    unless self.job
      self.job = job
      self.name = job.name
      self.user = user
      self.ugroup_id = user.ugroup_id
      self.ugroup_id = user.ugroups.first.id if !self.ugroup_id
      self.log = String.new
      self.note =  String.new
    end

    #
    #  look at each job item and see what lpars and commands we have
    #
    @rc = nil
    job.job_items.each do |ji|

      #
      #  look at each command in the group
      #
      @rv = nil
      ji.cgroup.commands.each do |command|

        #
        #  look at each lpar in the group
        #
        @rv = nil
        if ji.lgroup
          ji.lgroup.lpars.each do |lpar|
            #
            #  build a new RunCommand that we will send to a lpar
            #
            ctext = ctype(lpar, command, command.model.strip)
            @rc = RunCommand.new(run: self, lpar: lpar, model: ctext, job_item: ji, command: command)
            self.run_commands << @rc
            if %w(difcmd mvscmd).include? command.ctype.downcase
              @rv = RunView.create(run: self, run_command: @rc, job_item: ji, command: command, name: command.name,
              hide: command.hide)
              @rc.run_views << @rv
            end
          end
          #
          #  build a RunView that will use all the data acquired from the lpars
          #
          if !@rv && @rc
            @rv = RunView.create(run: self, run_command: @rc, job_item: ji,
            command: command, name: command.name, hide: command.hide)
            @rc.run_views << @rv
          end
        else
          if @rc == nil
            @rc = RunCommand.new(run: self, model: "", job_item: ji, command: command)
          end
          @rv = RunView.create(run: self, run_command: @rc, job_item: ji,
          command: command, name: command.name, hide: command.hide)
          @rc.run_views << @rv
        end

      end

    end

    #
    #  set background/notify/cache options
    #
    self.background = true
    self.background = false if job.run_type == "Real-Time"
    self.background = true if user.background == "Always"
    self.background = false if user.background == "Never"

    self.notify = job.notify
    self.notify = true if user.notify == "Always"
    self.notify = false if user.notify == "Never"

    self.cache = job.cache
    self.cache = true if user.cache == "Always"
    self.cache = false if user.cache == "Never"

    #
    #  set exp date
    #
    if job.keep_days
      self.delete_at = Date.today + job.keep_days
    end

    self.save

  end



  #
  #  see if we need to do any prompts
  #
  def prompts(lpar, command, ctext)
  end




  #
  #  build the command that will be sent to dif
  #
  def ctype(lpar, command, ctext)
    if command.ctype.downcase == "difcmd"
      return ctext
    elsif command.ctype.downcase == "mvscmd"
      return "OPERCMD #{ctext}"
    elsif command.ctype.downcase == "rexxcmd"
      return "REXX #{ctext}"
    elsif command.ctype.downcase == "external"
      return ctext
    elsif %w(grid chart xml csv).include?(command.ctype.downcase)
      mon = lpar.monproc
      mon = "MONRUNM" unless mon
      if ctext.downcase[0..3] == "dif "
        return ctext[4..-1]
      elsif command.ctype.downcase == "xml"
        return "ENABLE OSJOB #{mon} TCPIP *NAME=#{ctext},P2='XML(START)' "
      elsif command.ctype.downcase == "csv"
        return "ENABLE OSJOB #{mon} TCPIP *NAME=#{ctext},P2='WREC(CSV)' "
      else
        return "ENABLE OSJOB #{mon} TCPIP *NAME=#{ctext}"
      end
    end
  end


  #
  #  see if all the data is in cache
  #
  def try_cache
    if self.cache
      fin = true
      self.run_commands.each do | rc |
        unless rc.done or !rc.lpar
          ckey = "#{rc.lpar.id}/#{rc.model}"
          rc.rtext = Rails.cache.read(ckey)

          #
          #  there is data in the cache.
          #
          if rc.rtext
            self << "cache used: #{ckey}"
            rc.source = "Cache"
            rc.done = true
            rc.save
          else
            self << "no cache: #{ckey}"
            fin = false
          end

        else
          fin = false
        end
      end
    end

    #
    #  if we got all data from cache then return
    #
    self.done = true if fin
    self.save

  end


  #
  #  run the job to get the raw data from each lpar
  #
  def execute

    #
    #  build tcpip call for each run_command
    #
    self.xmlfile = Array.new
    execgroup = ExecGroup.new
    self.run_commands.each do | rc |
      unless rc.done or rc.lpar == nil
        rc.source = "TCPIP"
        exec = Exec.new
        exec.lpar = rc.lpar
        exec.cmd = rc.model
        exec.command = rc
        if %w(xml csv).include?(exec.command.command.ctype.downcase)
          exec.filename = ENV["HOMEDIR"] + "/tmp/" + exec.lpar.name + "-" + exec.command.command.file
          exec.xmlfile = ENV["HOMEDIR"] + "/tmp/" + exec.command.command.file
        end
        execgroup.execs << exec
      end
    end

    #
    #  run the tcpip requests
    #
    if execgroup.execs.count > 0
      self << "TCPIP started"
      self.save
      execgroup.run(self.user)
      if execgroup.errors
        self.error = true
        execgroup.errors.each { |t| self << t}
      end
      self << "TCPIP ended"
      self.save
    end

    #
    #  look at each request
    #
    execgroup.execs.each do |exec|
      rc = exec.command
      execgroup.errors = true if exec.errors

      #
      #  if we downloaded a dataset then build log message and keep the first 1k for display
      #
      if exec.file && !exec.errors
        self << "file downloaded (#{exec.rlength} bytes): #{exec.file.path}"
        f = File.open(exec.file.path)
        rc.rtext = f.read(1000)
        f.close
        if exec.xmlfile
          procxml(exec)
        end
      else
        rc.rtext = exec.rtext
      end

      rc.done = true
      rc.save

      #
      #  cache any data
      #
      if !rc.error && rc.command.cache_time && rc.command.cache_time > 0 && rc.rtext.present?
        ckey = "#{rc.lpar.id}/#{rc.model}"
        Rails.cache.write(ckey, rc.rtext, expires_in: rc.command.cache_time.minutes)
        self << "cache set: #{ckey}"
      end

    end

    #
    #  see if we are writting data to a local file
    #
    xmlfile.each do |f|
      path = f.path
      f.close
      fr = open(path).gets
      if fr[0..0] == "<"
        f = File.open(path, "a")
        f << '</root>'
        f.close
      end
      self << "File #{path} merged"
    end

    #
    #  check for any views that need to be generated from command
    #
    extview

    self.done = true
    self.end = DateTime.now
    self.save

  end


  #
  #  process any commands/views that are external
  #
  def extview

    #
    #  look at each run_command
    #
    rv = run_views
    rv.each do |rv|

      #
      #  if external see what commands we have
      #
      if rv.command.ctype.downcase == "external"

        rv.hide = true
        rv.save

        ecmds = rv.command.model.gsub(";","\n").strip
        ecmds.each_line do |cmd|
          oper = cmd.split(' ')
          oper[0] = "" if oper.count == 0

          #
          #  run a birt report
          #
          if oper[0].downcase == "birt"
            self << "BIRT started: #{oper[1]}"
            self.save
            cmd = "sh " + ENV["HOMEDIR"] + "/reports/birt.sh " + oper[1]
            crc = system(cmd)
            if crc
              self << "BIRT successful: #{oper[1]}"
            else
              self << "BIRT failed: #{oper[1]}"
              self.error = true
            end
            self.save
          end

          #
          #  run a linux command
          #
          if oper[0].downcase == "sh"
            self << "sh started: #{oper[1]}"
            self.save
            cmd = "sh " + oper[1]
            crc = system(cmd)
            if crc
              self << "sh successful: #{oper[1]}"
            else
              self << "sh failed: #{oper[1]}"
              self.error = true
            end
            self.save
          end

          #
          #  create new view and upload the pdf file
          #
          if oper[0].downcase == "view"
            upload(rv, oper[1], "PDF #{oper[1]}")
          end

          #
          #  mark a file for email attachment
          #
          if oper[0].downcase == "attach"
            attach(oper[1])
          end

        end
      end
    end
  end

  #
  #  upload file and create view
  #
  def upload(rv, fn, title)

    fn =  ENV["HOMEDIR"] + '/tmp/' + fn if fn[0..0] != "/"
    if File.exists?(fn)
      File.open(fn) do |f|
        rc = rv.run_command
        newrv = RunView.create(run: self, run_command: rc, file: f,
        name: title)
        self << "file uploaded: #{fn}"
        rc.run_views << rv
        rc.save
      end
    else
      self << "file does not exists: #{fn}"
    end
    self.save

  end

  #
  #  attach a file
  #
  def attach(pfn)
    fn = pfn
    fn =  ENV["HOMEDIR"] + '/tmp/' + pfn if fn[0..0] != "/"
    if File.exists?(fn)
      self.attachments ||= Hash.new
      self.attachments[pfn] = fn
    else
      self << "file does not exists: #{fn}"
    end
    self.save
  end


  #
  #  process xml and csv data
  #
  def procxml(exec)

    #
    #  create merge file if this is the first time he have seen it
    #
    fo = nil
    xmlfile.each do |f|
      if f.path == exec.xmlfile
        fo = f
        break
      end
    end

    if fo == nil
      fo = File.open(exec.xmlfile, 'w')
      xmlfile << fo
      if exec.command.command.ctype.downcase == "xml"
        fo << '<?xml version="1.0" encoding="ISO-8859-1"?>'
        fo << "\n"
        fo << "<root>\n"
      end
    end

    #
    #  read data from input file and write xml records to merge file
    #
    fi = File.open(exec.file, 'r')
    while(line=fi.gets("\r"))
      if exec.command.command.ctype.downcase == "csv" && line[0..9] == "MON10103-I"
          fo << line[11..-1] + "\n"
      elsif line[0..0] == "<" && !["<html>", "<?xml ", "<root>", "</root"].include?(line[0..5])
        fo << line + "\n"
      end
    end
    fi.close

    if self.debug
      attach(exec.file.path)
    end

  end


end
