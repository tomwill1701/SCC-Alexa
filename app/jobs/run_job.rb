class RunJob < ActiveJob::Base
require 'urbanairship'

  queue_as :run

  #
  #  run the job
  #
  def perform(run)

    if run.status == "Background run started"
      run.status = "Background run failed"
      run << "Background job failed"
      run.save
      return
    end

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

    job = run.job
    if job.alert_message.present? && job.alert_types.present?
      key = ENV["ALERT_KEY"]
      secret = ENV["ALERT_SECRET"]
      site = ENV["ALERT_SITE"]
      airship = Urbanairship::Client.new(key: key, secret: secret)
      push = airship.create_push
      push.audience = Urbanairship.tag(job.alert_types, group: site)
      push.notification = Urbanairship.notification(alert: job.alert_message)
      push.device_types = Urbanairship.all
      push.send_push
    end

    #
    #  delete trigger file name
    #
    if !run.file_delete.blank?
      File.delete(run.file_delete)
    end

  end

end
