class JobMailer < ApplicationMailer

  default from: 'tom@dtssoftware.com'

  def finished(run)

    @run = run
    @job = @run.job
    @user = @job.owner

    if run.attachments
      run.attachments.each do |k, v|
        attachments[k] = File.read(v)
        run << "email attachment: #{v}"
      end
    end

    if @user.email
      subject = "SCC job #{@run.name} has completed"
      subject =+ " but with errors" if @run.error
      mail(to: @user.email, subject: subject)
    end

  end

end
