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
    @run.start = DateTime.now
    @run.try_cache
    if @run.done
      @run.end = DateTime.now
    else
      if @run.background
        @run.status = "Background run queued"
        @run << "Background job queued at #{Time.now}"
        @run.save
        RunJob.perform_later @run
        @job = @run.job
        @rc = @run.run_commands
      else
        @run.execute(current_user) unless @run.done
        @run.end = DateTime.now
        @run.save
        #    if @run.done
        #      redirect_to job_run_view_path(@run)
        #    else
      end
    end

    @job = @run.job
    @rc = @run.run_commands
    if @run.notify
      JobMailer.finished(@run).deliver_now
      @run << "Email sent"
      @run.save
    end
    redirect_to run_path(@run)

  end


  def set_run
    @run = Run.find(params[:id]) if current_user
  end

end
