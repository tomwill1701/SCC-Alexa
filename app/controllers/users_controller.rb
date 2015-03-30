class UsersController < ApplicationController

  before_action :set_user

  #
  # update function
  #
  def update
    respond_to do |format|
      if @user.update(pin_params)
        format.html { redirect_to user_path, action: :edit,
            notice: 'User profile was successfully updated.' }
          format.json { render :edit, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @pin.errors, status: :unprocessable_entity }
        end
      end
    end


  def edit
  end

  #
  #  set pin based on its id
  #
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pin_params
    params.require(:user).permit(:title, :desc, :board_id, :url, :image, :image_cache)
  end


end