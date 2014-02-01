class ApplicationController < ActionController::Base

  def forem_user
    current_user
  end
  helper_method :forem_user

  protect_from_forgery

  helper_method :current_or_guest_user

  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # Find guest_user object associated with the current session,
  # or create one if needed.
  def guest_user
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user
  end

  # For creating error messages on object save/create.
  def error_msgs(obj)
    obj.errors.to_a.each { |e| e.capitalize }.join(". ")
  end

  private

  # Called once when the user logs in. 
  # Pass over anything from guest_user to current_user
  def logging_in
  end

  def create_guest_user
    u = User.create(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
    u.save!(:validate => false)
    session[:guest_user_id] = u.id
    u
  end
end
