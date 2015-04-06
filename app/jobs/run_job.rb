class RunJob < ActiveJob::Base

  queue_as :run

  #
  #  run the job
  #
  def perform(run)

    run.status = "Background run started"
    run << "Background job started at #{Time.now}"
    run.save
    unless run.done
      run.execute
      if run.notify
        JobMailer.finished(run).deliver_now
        run << "Email sent"
      end
    end

    run << "Background job ended at #{Time.now}"
    run.status = "Background run finished"
    run.save

  end

end
