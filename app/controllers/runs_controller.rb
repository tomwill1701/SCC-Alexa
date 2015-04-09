class RunsController < ApplicationController

  before_action :set_run, only: [:execute, :show, :destroy, :update]

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

  #
  # update function
  #
  def update
    respond_to do |format|
      if @run.update(run_params)
        format.html { redirect_to @run, notice: 'Run was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end


  #
  #  delete function
  #
  def destroy
    @run.destroy
    respond_to do |format|
      format.html { redirect_to runs_path, notice: 'Run was successfully deleted.' }
    end
  end

  #
  #  make sure the passed parms are ok
  #
  def run_params
    params.require(:run).permit(:ugroup_id, :note, :keep_days)
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

      else

        #
        #  run foreground
        #
        @run.status = "Real-time run started"
        @run.execute unless @run.done
        @run.end = DateTime.now
        @run.status = "Real-time run finished"
      end
    end

    #
    #  if job ran ok then display view else show run status
    #
    @run.save
    if @run.done && !@run.error
      redirect_to job_run_view_path(@run)
    else
      redirect_to run_path(@run)
    end

  end


  def set_run
    @run = Run.find(params[:id]) if current_user
  end

end




