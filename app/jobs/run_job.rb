class RunJob < ActiveJob::Base
  queue_as :run


  #
  #  turn off cache and run the job
  #
  def perform(run)

    run.cache == false
    run.status = "Background run started"
    run << "Background job started at #{Time.now}"
    run.save
    current_user = User.find_by(name: "tom")
    run.execute(current_user) unless run.done
    run << "Background job ended at #{Time.now}"
    run.status = "Background run done"
    run.save
    
  end
end
