class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]

    if user && user.authenticate(params[:password])
      if  user.access_denied
        redirect_to :back, alert: "Your account is frozen, contact to support" and return
      end
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end

  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end