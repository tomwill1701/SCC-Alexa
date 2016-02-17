# == Schema Information
#
# Table name: runs
#
#  id          :integer          not null, primary key
#  background  :boolean          default(TRUE)
#  cache       :boolean          default(TRUE)
#  error       :boolean          default(FALSE)
#  done        :boolean          default(FALSE)
#  notify      :boolean          default(FALSE)
#  debug       :boolean          default(FALSE)
#  name        :string
#  status      :string
#  error_text  :string
#  log         :text
#  total_data  :integer
#  start       :datetime
#  end         :datetime
#  viewed      :datetime
#  delete_at   :datetime
#  delete_when :string
#  note        :string
#  auto_run    :boolean          default(FALSE)
#  ugroup_id   :integer
#  job_id      :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  file_delete :string
#

class RunsController < ApplicationController

  before_action :set_run, only: [:execute, :show, :destroy, :update]

  def index
    if current_user
      @q = current_user.runs.ransack(params[:q])
      @runs = @q.result.includes(:ugroup, :job).page(params[:page])
    else
      flash[:warning] = "You must be signed-in to view this page."
      redirect_to root_path
    end
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
        @run << "Background job queued"
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
