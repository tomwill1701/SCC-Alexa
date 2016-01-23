namespace :scc do

  desc "SCC Autorun"

  task arstart: :environment do

    delete
    autorun

  end

  task ar: :environment do

    delete
    autorun

  end

  #
  #  delete any run that is at its auto delete date
  #
  def delete

    runs = Run.where("delete_at <= ?", Date.today)
    runs.each do |r|
      r.destroy
      puts "Run #{r.id} deleted : ran: #{r.start} / user: #{r.user.username} / name: #{r.job.name}"
    end

  end

  #
  #  start any job with an valid auto start criteria
  #
  def autorun

    jobs = Job.where("ar_type is not NULL AND ar_start_date <= ? AND
        (ar_start_time is NULL OR ar_start_time <= ?)", Date.today, Time.now)

    jobs.each do |j|
      binding.pry
    end

  end

end
