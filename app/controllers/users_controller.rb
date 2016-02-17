# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  name            :string
#  department      :string
#  phone           :string
#  email           :string
#  racf_userid     :string
#  racf_group      :string
#  racf_password   :string
#  admin           :boolean          default(FALSE)
#  password_digest :string
#  last_login      :datetime
#  login_count     :integer          default(0)
#  background      :string
#  notify          :string
#  cache           :string
#  prompt_ok       :string
#  prompt_cancel   :string
#  prompt_values   :string
#  prompt_fields   :string
#  lpar_id         :integer
#  command_id      :integer
#  job_id          :integer
#  ugroup_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UsersController < ApplicationController

  before_action :set_user

  #
  # update function
  #
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_user_path(@user),
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
          :background, :notify, :cache, :ugroup_id)
  end


end
