class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[ show edit update destroy ]

  # GET /organizations or /organizations.json
  def index
    @organizations = current_user.organizations
  end

  # GET /organizations/1 or /organizations/1.json
  def show
    if current_user.organization_users.find_by(organization: @organization, role: "admin").present?
      @contents = @organization.contents
    else
      @contents = @organization.contents.where(age_group: current_user.age_group)
    end
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations or /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        @organization.organization_users.create(user: current_user, role: "admin")
        format.html { redirect_to @organization, notice: "Organization was successfully created." }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1 or /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: "Organization was successfully updated." }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1 or /organizations/1.json
  def destroy
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_path, status: :see_other, notice: "Organization was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_user
    @organization = current_user.organizations.find(params[:id])
    user = User.find_by(email: params[:email])

    if user
      membership = @organization.organization_users.find_or_initialize_by(user: user)
      membership.role = params[:role] || "member"
      if membership.save
        redirect_to @organization, notice: "#{user.name} was added as a #{membership.role}."
      else
        redirect_to @organization, alert: "Could not add user."
      end
    else
      redirect_to @organization, alert: "User with that email not found."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = current_user.organizations.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.require(:organization).permit(:name, :description)
    end
end
