class RunsController < ApplicationController

  before_action :set_run, only: [:execute, :show, :destroy]

  def index
    @q = current_user.runs.ransack(params[:q])
    @runs = @q.result.includes(:ugroup, :job).page(params[:page])
  end

  #
  #  show function
  #
  def show
    @job = @run.job
    @rc = @run.run_commands
  end

  #  delete function
  #
  def destroy
    @run.destroy
    respond_to do |format|
      format.html { redirect_to runs_path, notice: 'Run was successfully deleted.' }
    end
  end

  #
  #  execute function
  #
  def execute

    #
    #  get the prompt values
    #

    #
    #  do symbolic subsituation
    #

    #
    #  execute the job to get the data
    #

    #
    #  try cache
    #
    @run.start = DateTime.now
    @run.try_cache
    if @run.done
      @run.end = DateTime.now

    else
      #
      #  see if we need to run background
      #
      if @run.background
        @run.status = "Background run queued"
        @run << "Background job queued at #{Time.now}"
        @run.save
        RunJob.perform_later @run

      #
      #  run forground
      #
      else
        @run.status = "Real-time run"
        @run.execute(current_user) unless @run.done
        @run.end = DateTime.now
        @run.status = "Real-time run finished"
        #
        #  if job ran ok then display view else show run status
        #
        if @run.done && !@run.error
          @run.save
          redirect_to job_run_view_path(@run)
          return
        end
      end
    end

=begin
    if @run.notify
      JobMailer.finished(@run).deliver_now
      @run << "Email sent
    end
=end

    #
    #  show run status
    #
    @run.save
    redirect_to run_path(@run)

  end


  def set_run
    @run = Run.find(params[:id]) if current_user
  end

end
