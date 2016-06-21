class Api::RunsController < Api::ApiController

  before_action :set_run, only: [:show, :destroy]

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
  def destroy
    @run.destroy
    ender status: 200, json: {
      message: "Run successfully deleted.",
      run: @run
    }.to_json
  end

  private
  def list_params
    params.require(:run)
  end

  def set_run
    @run = current_user.runs.find(params[:id])
    # @run = Run.find(params[:id]) if current_user
  end

end