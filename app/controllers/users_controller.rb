class UsersController < BaseController

  before_action :authorizate_request!
  skip_before_action  :authorizate_request!, only: [:create]

  def current_user
    render json: {
      user: {
        id: @current_user.id,
        name: @current_user.name,
        avatar: @current_user.avatar_url
      }
    }, status: 200
  end

  def user
    begin
      user = User.find(params[:id])
    rescue
      render_errors({"errors-list" => "Wrong id provided"}, 404) and return
    end
    render json: {
      user: {
        id: user.id,
        name: user.name,
        avatar: user.avatar_url
      }
    }, status: 200
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: { user: { id: user.id, name: user.name,
                       token: user.auth_token }}, status: 201
    else
      render_errors(user.errors, 422)
    end
  end

  def index
    users = []
    filter = params[:filter] || ""
    User.order(:name).where("name ~* ?", "^#{filter}").page(params[:page]).per(20).map do |user|
      users.push({ id: user.id, name: user.name, avatar: user.avatar_url})
    end
    render json: { users: users }
  end

  def update
    avatar = params.require(:user).permit(:avatar)
    if @current_user.update_attributes(avatar)
      render json: {
        user: {
          avatar: @current_user.avatar_url
        }}
    else
      render_errors(@current_user.errors, 422)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
