class RunJob < ActiveJob::Base

  queue_as :run

  #
  #  run the job
  #
  def perform(run)

    return if run.status == "Background run started"
    run.status = "Background run started"
    run << "Background job started"
    run.save
    unless run.done
      run.execute
      if run.notify
        JobMailer.finished(run).deliver_now
        run << "Email sent"
      end
    end

    run << "Background job ended"
    run.status = "Background run finished"
    Notice.create(title: "Background job finished", ugroup: run.ugroup, run: run)
    run.save

    #
    #  delete trigger file name
    #
    if !run.job.ar_file.blank?
      fn = run.job.ar_file
      if fn[0..0] != '/'
        fn = ENV["HOMEDIR"] + "/tmp/" + run.job.ar_file
      end
      File.delete(fn)
    end

  end

end
