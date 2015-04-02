class JobsController < ApplicationController

  before_action :set_job_update, only: [:destroy, :update, :edit, :clone, :favorite, :unfavorite]
  before_action :set_job, only: [:show, :run]

  def index
    if current_user
      @q = Job.for_user(current_user).includes(:user_jobs).ransack(params[:q])
      @jobs = @q.result(distinct: true).page(params[:page]).per(15)
    end
  end

  #
  #  create a new job
  #
  def new
    @job = Job.new
    @job.private = true
    @job.owner = current_user
  end

  #
  #  edit function
  #
  def edit
  end

  #
  #  show function
  #
  def show
  end

  #
  #  clone the existing job and make it private for this user
  #
  def clone
    @job = @job.dup
    @job.private = true
    @job.owner = current_user
    render :edit
  end

  #
  #  create function
  #
  def create
    @job = Job.new(job_params)

    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  #
  #  update function
  #
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  #
  #  delete function
  #
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_path, notice: 'Job was successfully deleted.' }
      end
    end

  #
  #  run function
  #
  def run
    run = Run.new
    run.build(@job, current_user)
    run.save
    redirect_to execute_run_path(run)
  end

  #
  #  mark a job as favoorite
  #
  def favorite
    UserJob.find_or_create_by(user: current_user, job: @job)
    redirect_to :back
  end

  #
  #  remove the favorite link
  #
  def unfavorite
    UserJob.find_or_create_by(user: current_user, job: @job).destroy
    redirect_to :back
  end

  #
  #  find the job for the passed id
  #
  def set_job_update
    @job = Job.for_user(current_user).find(params[:id]) if current_user
  end
  def set_job
    @job = Job.for_user(current_user).find(params[:id]) if current_user
  end

  #
  #  make sure the passed parms are ok
  #
  def job_params
    params.require(:job).permit(:name, :description, :menu, :cclass, :tags, :jtype,
      :when, :when_time, :private, :notify, :user_ids, :owner_id,
      :run_type, :keep_days, :cache,
      job_items_attributes: [:id, :cgroup_id, :lgroup_id, :cache, :chart_type,
          :chart_x, :chart_y, :chart_opt, :size, :_destroy])
  end


end