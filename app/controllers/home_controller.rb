class HomeController < ApplicationController
  def index
    @pending_minors = User.where(parent_email: current_user&.email, parent_confirmed: [false, nil])
  end

  def confirm
    child = User.find(params[:id])

    if child.parent_email == current_user.email
      child.update(parent_confirmed: true)
      redirect_to root_path, notice: "You have successfully confirmed your child’s account."
    else
      redirect_to root_path, alert: "Unauthorized confirmation."
    end
  end
end
