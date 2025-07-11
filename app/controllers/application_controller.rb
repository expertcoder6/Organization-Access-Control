class ApplicationController < ActionController::Base
	def after_sign_in_path_for(resource)
	  root_path
	end

	before_action :configure_permitted_parameters, if: :devise_controller?

	before_action :check_parental_consent

	protected

	def check_parental_consent
	  return unless user_signed_in?

	  if current_user.minor? && !current_user.parent_confirmed
	    sign_out(current_user)
	    redirect_to root_path, alert: "Parental consent required."
	  end
	end

	def configure_permitted_parameters
	  devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :date_of_birth, :parent_email])
	end
end
