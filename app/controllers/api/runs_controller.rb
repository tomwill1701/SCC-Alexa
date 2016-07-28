class Api::RunsController < Api::ApiController

  before_action :set_run, only: [:show, :delete]

  #
  #  index
  #
  def index
    render json: current_user.runs
  end

  #
  #  show
  #
  def show
    render json: @run
  end

  #
  #  delete function
  #
  def delete
    @run.destroy
    render status: 200, json: {
      message: "Run successfully deleted",
      run: @run
    }.to_json
  end

  private
  def list_params
    params.require(:run)
  end

  def set_run
    @run = current_user.runs.find(params[:id])
  end

end