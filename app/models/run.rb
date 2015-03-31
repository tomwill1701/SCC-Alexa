# == Schema Information
#
# Table name: runs
#
#  id         :integer          not null, primary key
#  background :boolean          default("false")
#  error      :boolean          default("false")
#  done       :boolean          default("false")
#  status     :string
#  error_text :string
#  log        :text
#  start      :datetime
#  end        :datetime
#  viewed_at  :datetime
#  delete_at  :datetime
#  ugroup_id  :integer
#  job_id     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Run < ActiveRecord::Base

  belongs_to :ugroup
  belongs_to :job
  belongs_to :user

  has_many :run_commands, dependent: :destroy
  has_many :run_views, through: :run_commands

  scope :with_background, -> { where("background = true")  }
  scope :with_error, -> { where("error = true")  }
  scope :with_done, -> { where("done = true")  }
  scope :with_nv, -> { where("viewed_at IS NULL")  }

  #
  #  ransack filters
  #
  def self.ransackable_scopes(auth_object = nil)
    [:with_background, :with_error, :with_done, :with_nv]
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
  def build(jobid, user)

    #
    #  find the current job and build a new run
    #
    job = Job.find(jobid)
    unless self.job
      self.job = job
      self.user = user
      self.ugroup = user.ugroups.first
    end

    #
    #  look at each job item and see what lpars and commands we have
    #
    job.job_items.each do |ji|
      @rc = nil
      #
      #  look at each command in the group
      #
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
            @rc = RunCommand.new(run: self, lpar: lpar, command: command, model: ctext)
            self.run_commands << @rc
            if %w(DIFCmd MVSCmd).include? command.ctype
              @rv = RunView.new(run_command: @rc, command: command, job_item: ji)
              @rc.run_views << @rv
            end
          end
          #
          #  build a RunView that will use all the data acquired from the lpars
          #
        end
        unless @rv
          @rc.run_views << RunView.new(run_command: @rc, command: command, job_item: ji) if @rc
        end
      end
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
      return ctext.gsub(' ','+')
    elsif command.ctype == "MVSCmd"
      return "OPERCMD #{ctext}".gsub(' ','+')
    elsif command.ctype == "REXXCmd"
      return "REXX #{ctext}".gsub(' ','+')
    elsif %w(Grid Chart).include?(command.ctype)
      mon = lpar.monproc
      mon = "MONRUNM" unless mon
      return "ENABLE OSJOB #{mon} TCPIP *NAME=#{ctext}".gsub(' ','+')
    end
  end

  #
  #  run the job to get the raw data from each lpar
  #
  def execute(current_user)

    #
    #  see if all the data is in cache
    #
    unless self.background
      fin = true
      self.run_commands.each do | rc |
        unless rc.done
          if rc.command.cache_time > 0
            ckey = "#{rc.lpar.id}/#{rc.model}"
            rc.rtext = Rails.cache.read(ckey)
            if rc.rtext
              puts rc.rtext
              self << "cache: #{ckey} used"
              rc.source = "Cache"
              rc.save
            else
              self << "cache: #{ckey} not found"
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
      if fin
        self.done = true
        self.save
        return
      end

    end

    #
    #  build tcpip call for each run_command
    #
    execgroup = ExecGroup.new
    self.run_commands.each do | rc |
      unless rc.done
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
    execgroup.run(current_user)

    #
    #  look at each request
    #
    execgroup.execs.each do |exec|
      rc = exec.command
      execgroup.error = true if exec.errors
      rc.rtext = exec.rtext
      rc.done = true
      rc.save

      if !rc.error && rc.rtext.length > 0 && rc.command.cache_time > 0
        ckey = "#{rc.lpar.id}/#{rc.model}"
        Rails.cache.write(ckey, rc.rtext, expires_in: rc.command.cache_time.seconds)
        self << "cache: #{ckey} set"
      end

    end
    self.done = true
    self.save

  end


end
