class HomeController < ApplicationController

  before_action :set_notice, only: [:destroy]

  #
  #  get list of current notices and last runs
  #
  def index
    if current_user
      @notices = current_user.notices.includes(:ugroup)
      @runs = current_user.runs.includes(:job, :ugroup).where("viewed is NULL")
    else
      flash[:warning] = "You must be signed-in to view this page."
      redirect_to root_path
    end
  end

  #
  #  delete function
  #
  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to home_index_path }
    end
  end

  def set_notice
    @notice = Notice.find(params[:id]) if current_user
  end


  end
