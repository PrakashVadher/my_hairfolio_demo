module Authenticable

  def current_user
    # if session["warden.user.user.key"]
    #   @current_user ||= User.find_by(id: session["warden.user.user.key"][0][0])
    # else
    #   @current_user ||= request.headers['Authorization'] ? User.find_by(auth_token: request.headers['Authorization']) : nil
    # end
    @current_user ||= request.headers['Authorization'] ? User.unscoped.find_by(auth_token: request.headers['Authorization']) : nil
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  def check_user
    current_user
    if current_user.present?
      @user_id = current_user.id
    else
      @user_id = ''
    end  
  end

end
