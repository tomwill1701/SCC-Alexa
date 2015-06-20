class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  helper :all

  helper_method :current_user, :names_comma, :name_qual

  #
  #  get the current user
  #
  #  also make sure we have a prompt values hash for this user
  #
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    return @current_user
  end

  #
  #  make sure this user is an admin
  #
  def authenticate_admin_user!
    unless current_user.try(:admin?)
      flash[:notice] = "This area is restricted to administrators only."
      redirect_to root_path
    end
  end

  #
  #  try to sign this user in
  #
  def signin
    @current_user = User.find_by(name: params[:name]).try(:authenticate, params[:password])
    if @current_user
      session[:user_id] = @current_user.id
      flash[:notice] = "Success"
    else
      flash[:error] = "Signin failed"
    end
    redirect_to home_index_path
  end

  #
  #  sign this user out
  #
  def signout

    if current_user
      current_user.prompt_values = nil
      current_user.save
    end
    session.delete :user_id

    flash[:notice] = "Successfully Signed Out"
    redirect_to root_path
  end


  #
  #  return list of names seperated by comma
  #
  def names_comma(col, u = false, g = "")
    return col.map { |d| name_qual(d, u, g) }.join(", ").html_safe
  end


  #
  #  return name qualified by u- or g-
  #
  def name_qual(obj, u = false, g = "")
    if obj
      if u == false
        return obj.name
      elsif obj.ind
        return u + obj.name
      else
        return g + obj.name
      end
    end
  end

end
