class RunJob < ActiveJob::Base

  queue_as :run

  #
  #  run the job
  #
  def perform(run)

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

  end

end
