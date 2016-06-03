class MembersController < ApplicationController

  before_action :load_user_and_organization

  def index
    load_members
  end

  def new
    build_member
  end

  def create
    build_member
    save_member or render :new
  end

  def edit
    load_member
    build_member
  end

  def update
    load_member
    build_member
    save_member or render :edit
  end

  def destroy
    load_member
    @member.destroy
    redirect_to organization_path @organization
  end

  private

    def load_user_and_organization
      @user ||= current_user
      @organization ||= user_organizations.find_by(id: params[:organization_id])
    end

    def load_members
      @members ||= (@organization ? organization_members : user_members)
    end

    def load_member
      @member ||= organization_members.find(params[:id])
    end

    def build_member
      @member ||= organization_members.build
      @member.attributes = member_params
    end

    def save_member
      if @member.save
        redirect_to organization_path @organization
      end
    end

    def member_params
      member_params = params[:member]
      member_params ? member_params.permit(:title, :first_name, :date_of_birth,
                              :phone, :email, :information, { group_ids: [] },
                              phones_attributes: [:id, :category,
                                                  :number, :member_id, 
                                                  :_destroy]) : {}
    end

    def user_organizations
      @user.organizations
    end

    def organization_members
      if params[:keywords].present?
        Member::Search.new(@organization.members, params[:keywords]).result
      else
        @organization.members.by_first_name
      end
    end

    def user_members
      if params[:keywords].present?
        Member::Search.new(@user.members, params[:keywords]).result
      else
        @user.members.by_name_and_first_name
      end
    end
end
