class RunJob < ActiveJob::Base
  queue_as :run

  def perform(run)
    run.cache == false
    run.status = "Background run started"
    run.save
    run.execute(current_user) unless run.done
    run.status = "Background run done"
    run.save
  end
end
