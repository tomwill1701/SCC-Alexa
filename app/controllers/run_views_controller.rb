class RunViewsController < ApplicationController

  before_action :set_views, only: [:show]

  def index
  end

  #
  #  show function
  #
  def show
    @rc = @rv.run_command
    @rv = [@rv]
  end

  #
  #  show all views for the run
  #
  def job
    @run = Run.find(params[:id])
    @run.viewed = DateTime.now
    @run.save
    @rv = @run.run_views
    render :show
  end

  def set_views
    @rv = RunView.find(params[:id])
  end


end