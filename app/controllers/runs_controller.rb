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
    if self.background
      @run.status = "Background run queued"
      @run.save
      Run.perform_later @run
      @job = @run.job
      @rc = @run.run_commands
      render :show
    else
      @run.execute(current_user) unless @run.done
      @run.save
#    if @run.done
#      redirect_to job_run_view_path(@run)
#    else
        @job = @run.job
        @rc = @run.run_commands
        render :show
#    end
    end

  end


  def set_run
    @run = Run.find(params[:id]) if current_user
  end

end
