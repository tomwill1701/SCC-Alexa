namespace :scc do

  desc "SCC Autorun"

  task ar: :environment do

    pid = "#{Rails.root}/tmp/pids/ar.pid"
    File.open(pid, 'w'){|f| f.puts Process.pid}

    while true
      delete
      autorun
      sleep 60
    end


  end

  task ar1: :environment do

    delete
    autorun

  end

  #
  #  delete any run that is at its auto delete date
  #
  def delete

    runs = Run.where("delete_at <= ?", Date.today)
    runs.each do |run|
      run.destroy
      puts "Run #{run.id} deleted : ran: #{run.start} / user: #{run.user.username} / name: #{run.job.name}"
    end

  end

  #
  #  start any job with an valid auto start criteria
  #
  def autorun

    jobs = Job.where("length(ar_type) > 0 AND
        (ar_start_date is null OR ar_start_date <= ?) AND
        (ar_start_time is null OR ar_start_time <= ?)", Date.today, Time.now)
    jobs.each do |job|

      file_delete = nil

      #
      #  hour of the day
      #
      if !job.ar_hour.blank?
        a = job.ar_hour.split(",").map { |s| s.to_i }
        break if !a.include?(Time.now.hour)
      end

      #
      #  day of the month
      #
      if !job.ar_day.blank?
        a = job.ar_day.split(",").map { |s| s.to_i }
        break if !a.include?(Time.now.day)
      end

      #
      #  month of the year
      #
      if !job.ar_month.blank?
        a = job.ar_month.split(",").map { |s| s.to_i }
        break if !a.include?(Time.now.month)
      end

      #
      #  day of the week
      #
      if !job.ar_wday.blank?
        a = job.ar_wday.split(",")
        break if !a.include?(Time.now.strftime("%A")) and
                !a.include?(Time.now.strftime("%a"))
      end

      #
      #  trigger file name
      #
      if !job.ar_file.blank?
        fns = job.ar_file.split(';')
        fn = fns[0]
        cfn = fns[1]
        if fn[0..0] != '/'
          fn = Rails.root.to_s + "/tmp/" + fn
          cfn = Rails.root.to_s + "/tmp/" + cfn if cfn
        end

        #
        #  see if the file exists and has changed since we last used it
        #
	 last_mod = File.mtime(fn).to_s
        if File.exist?(fn) and !File.zero?(fn) and File.readable?(fn) and
           (job.ar_file_modified == nil or job.ar_file_modified != last_mod )

           job.ar_file_modified = last_mod

           #
           #  see if we need to copy to a new file
           #
           if cfn != nil
             FileUtils.cp(fn, cfn)
           end
        else
          break
        end
      end

      #
      #  start a new run
      #
      run = Run.new
      run.start = DateTime.now
      run.build(job, job.owner)
      run.status = "Autorun job queued"
      run << "Autorun job queued"
      run.auto_run = true
      run.file_delete = file_delete
      run.save
      RunJob.perform_later run

      puts "Run #{run.id} started : ran: #{run.start} / user: #{run.user.username} / name: #{run.job.name}"

      #
      #  calc new start time
      #
      if job.ar_type == "Minute"
        newstart = Time.now + 1.minute
      elsif job.ar_type == "Hour"
        newstart = Time.now + 1.hour
      elsif job.ar_type == "Day"
        newstart = Time.now + 1.day
      elsif job.ar_type == "Month"
        newstart = Time.now + 1.month
      elsif job.ar_type == "Once"
        newstart = nil
      end

      if newstart == nil
        job.ar_start_date = nil
        job.ar_start_time = nil
      else
        job.ar_start_date = newstart.to_date
        job.ar_start_time = newstart.to_time
      end

      job.ar_active = true
      job.save

    end

  end

end
