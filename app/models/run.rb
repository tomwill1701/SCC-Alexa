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
#  ugroup_id   :integer
#  job_id      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  note        :string
#  delete_when :string
#

class Run < ActiveRecord::Base

  attr_accessor :select

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

  attr_accessor :keep_days

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
    self.log += string + "\r"
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
  #  and one ore more run_views attached to the command to show text/grid/charts
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
            ctext = ctype(lpar, command, command.model)
            @rc = RunCommand.new(run: self, lpar: lpar, model: ctext, job_item: ji, command: command)
            self.run_commands << @rc
            if %w(DIFCmd MVSCmd).include? command.ctype
              @rv = RunView.create(run: self, run_command: @rc, job_item: ji, command: command)
              @rc.run_views << @rv
            end
          end
          #
          #  build a RunView that will use all the data acquired from the lpars
          #
          if !@rv && @rc
            @rv = RunView.create(run: self, run_command: @rc, job_item: ji,
            command: command)
            @rc.run_views << @rv
          end
        end
        if !@rv && @rc
          @rv = RunView.create(run: self, run_command: @rc, job_item: ji,
          command: command)
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
    if command.ctype == "DIFCmd"
      return ctext
    elsif command.ctype == "MVSCmd"
      return "OPERCMD #{ctext}"
    elsif command.ctype == "REXXCmd"
      return "REXX #{ctext}"
    elsif command.ctype == "External"
      return ctext
    elsif %w(Grid Chart).include?(command.ctype)
      mon = lpar.monproc
      mon = "MONRUNM" unless mon
      return "ENABLE OSJOB #{mon} TCPIP *NAME=#{ctext}"
    end
  end


  #
  #  see if all the data is in cache
  #
  def try_cache
    if self.cache
      fin = true
      self.run_commands.each do | rc |
        unless rc.done
          ckey = "#{rc.lpar.id}/#{rc.model}"
          rc.rtext = Rails.cache.read(ckey)
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
    execgroup = ExecGroup.new
    self.run_commands.each do | rc |
      unless rc.done
        rc.source = "TCPIP"
        exec = Exec.new
        exec.lpar = rc.lpar
        exec.cmd = rc.model
        exec.command = rc
        execgroup.execs << exec
      end
    end

    #
    #  run the tcpip requests
    #
    self << "TCPIP started at #{Time.now}"
    self.save
    execgroup.run(self.user)
    if execgroup.errors
      self.error = true
      execgroup.errors.each { |t| self << t}
    end
    self << "TCPIP ended at #{Time.now}"
    self.save

    #
    #  look at each request
    #
    execgroup.execs.each do |exec|
      rc = exec.command
      execgroup.errors = true if exec.errors
      rc.rtext = exec.rtext
      rc.done = true
      rc.save

      if !rc.error && rc.command.cache_time && rc.command.cache_time > 0 && rc.rtext.length > 0
        ckey = "#{rc.lpar.id}/#{rc.model}"
        Rails.cache.write(ckey, rc.rtext, expires_in: rc.command.cache_time.minutes)
        self << "cache set: #{ckey}"
      end

    end

    #
    #  check for any views that are external
    #

    extview

    self.done = true
    self.end = DateTime.now
    self.save

  end

  #
  #  process any views that are external
  #
  def extview

    rv = self.run_views
    rv.each do |rv|
      if rv.command.ctype == "External"
        operands = rv.command.model.split(' ')
        if operands[0].downcase == "pdf"
          File.open(operands[1]) do |f|
            rv.file = f
          end
        end
      end
      rv.save
    end
  end


end
