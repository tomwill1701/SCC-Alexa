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
    @rv = @run.run_views.includes(:run_command, :run)
    render :show
    if @run.delete_when == "ViewedXX"
      @run.delete
    else
      @run.save
    end
  end

  #
  # get current RunView
  #
  def set_views
    @rv = RunView.find(params[:id])
    @run = @rv.run
  end


end