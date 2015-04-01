class UsersController < ApplicationController

  before_action :set_user

  #
  # update function
  #
  def update
    respond_to do |format|
      if @user.update(user_params)
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
  #  set user based on its id
  #
  def set_user
    @user = current_user
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :department, :phone, :email, :lpar_id,
          :racf_userid, :racf_group, :racf_password, :password,
          :background, :notify, :cache)
  end


end