class GroupsController < ApplicationController

  before_action :load_user

  def index
    load_groups
  end

  def show
    load_group
  end

  def new
    build_group
  end

  def create
    build_group
    save_group or render :new
  end

  def edit
    load_group
    build_group
  end

  def update
    load_group
    build_group
    save_group or render :edit
  end

  def destroy
    load_group
    @group.destroy
    redirect_to groups_path
  end

  private

    def load_user
      @user = current_user
    end

    def load_groups
      @groups ||= user_groups
    end

    def load_group
      @group ||= user_groups.find(params[:id])
    end

    def build_group
      @group ||= user_groups.build
      @group.attributes = group_params
    end

    def save_group
      if @group.save
        redirect_to groups_path
      end
    end

    def group_params
      group_params = params[:group]
      group_params ? group_params.permit(:name, :description, :website) : {}
    end

    def user_groups
      @user.groups
    end
end