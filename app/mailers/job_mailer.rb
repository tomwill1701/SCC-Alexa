class JobMailer < ApplicationMailer

  default from: 'tom@dtssoftware.com'

  def finished(run)

    @run = run
    @job = @run.job
    @user = @job.owner

    if run.attachments
      run.attachments.each do |k, v|
        run << "email attachment: #{v}"
        run.save
        attachments[k] = File.read(v)
      end
    end

    if @user.email
      subject = "RCC Job #{@run.name} has completed"
      subject = "RCC Job #{@run.name} has completed but with errors" if @run.error
      mail(to: @user.email, subject: subject)
    end

  end

end
