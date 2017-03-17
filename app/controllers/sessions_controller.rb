class SessionsController < BaseController

  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      render_user(user)
    else
     render_login_errors
    end
  end

  def destroy
    user = User.find(params[:id])
    if user
      user.regenerate_auth_token
    end
    head 204 and return
  end

  private

  def render_user(user)
    render json: { user: { id: user.id, name: user.name,
                     token: user.auth_token }}
  end

  def render_login_errors
    login_errors = { login: "Invalid email or password"}
    render_errors(login_errors, 403)
  end
end