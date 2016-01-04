class OrganizationsController < ApplicationController

  before_action :load_user

  def index
    load_organizations
  end

  def show
    load_organization
    load_members
  end

  def new
    build_organization
  end

  def create
    build_organization
    save_organization or render :new
  end

  def edit
    load_organization
    build_organization
  end

  def update
    load_organization
    build_organization
    save_organization or render :edit
  end

  def destroy
    load_organization
    @organization.destroy
    redirect_to organizations_path
  end

  private

    def load_user
      @user ||= current_user
    end

    def load_organizations
      @organizations ||= user_organizations
    end

    def load_members
      if params[:keywords].present?
        @members ||= Member::Search.new(@organization.members, 
                                        params[:keywords]).result
      else
        @members ||= @organization.members
      end
    end

    def load_organization
      @organization ||= user_organizations.find(params[:id])
    end

    def build_organization
      @organization ||= user_organizations.build
      @organization.attributes = organization_params
    end

    def save_organization
      if @organization.save
        redirect_to organizations_path
      end
    end

    def organization_params
      organization_params = params[:organization]
      organization_params ? organization_params
                            .permit(:name, :street, :zip, :town,
                                    :country, :email, :website,
                                    :information, :phone) : {}
    end

    def user_organizations
      @user.organizations
    end
end
