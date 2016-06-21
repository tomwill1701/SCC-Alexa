class Api::JobsController < Api::ApiController

  before_action :set_job, only: [:show, :run]

  def index
    #render  json: Job.for_user(current_user).to_json(include: { runs: { include: :run_views } })
    render json: Job.for_user(current_user).with_jgroup(@title)
  end

  def show
    render json: @job
  end

  #
  #  find the job for the passed id
  #
  def set_job
    @job = Job.for_user(current_user).find(params[:id]) if current_user
  end

end
