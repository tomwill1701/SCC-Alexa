class Api::JobsController < Api::ApiController

  before_action :set_job, only: [:show, :run]

  def index
    #render  json: Job.for_user(current_user).to_json(include: { runs: { include: :run_views } })
    render json: Job.for_user(current_user).with_jgroup(@title)
  end

  def show
    render json: @job
  end

  def run
    @run = Run.new
    @run.build(@job, current_user)
    @run.status = "Background run queued"
    @run << "Job created from API"
    @run << "Background job queued"
    @run.start = DateTime.now
    @run.save
    render json: @run
    RunJob.perform_later @run
  end

  #
  #  find the job for the passed id
  #
  def set_job
    @job = Job.for_user(current_user).find(params[:id]) if current_user
  end

end
