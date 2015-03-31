class RunViewsController < ApplicationController

  before_action :set_views, only: [:show]

  def index
  end

  #
  #  show function
  #
  def show
    @rc = @rv.run_command
    @rc.build
    @rv = [@rv]
  end

  #
  #  show all views for the run
  #
  def job
    @rv = Run.find(params[:id]).run_views.first
    @rc = @rv.run_command.build
  end

  def set_views
    @rv = RunView.find(params[:id]) if current_user
  end


end