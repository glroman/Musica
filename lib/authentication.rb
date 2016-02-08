
module Authentication
  def authenticate!
    return if session[:user]
    session[:original_request] = request.path_info
    redirect '/login'
  end
end
