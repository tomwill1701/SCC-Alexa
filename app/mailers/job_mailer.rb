class JobMailer < ApplicationMailer

  default from: 'tom@dtssoftware.com'

  def finished(run)

    @run = run
    @job = @run.job
    @user = @job.owner
    if @user.email
      subject = "SCC job #{@run.name} has completed"
      subject =+ " but with errors" if @run.error
      mail(to: @user.email, subject: subject)
    end

  end

end
