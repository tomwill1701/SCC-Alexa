class Api::JobsController < Api::ApiController

  def index
    #render  json: Job.for_user(current_user).to_json(include: { runs: { include: :run_views } })
    render json: Job.for_user(current_user).with_jgroup(@title)
  end

  def show
    list = current_user.jobs.find(params[:id])
    render json: list
  end

end
