class Groups::MembersController < ApplicationController

  before_action :load_user_and_group

  def index
    load_group_members
    load_non_group_members
  end

  def add
    load_member
    add_member_to_group
    redirect_to group_members_path @group
  end

  def remove
    load_member
    remove_member_from_group
    redirect_to group_members_path @group
  end

  private

    def load_user_and_group
      @user ||= current_user
      @group ||= user_groups.find(params[:group_id])
    end

    def load_group_members
      @group_members ||= group_members
    end

    def load_non_group_members
      @non_group_members ||= non_group_members
    end

    def load_member
      @member ||= all_members.find(params[:id])
    end

    def add_member_to_group
      @group.members << @member
    end

    def remove_member_from_group
      @group.members.delete(@group.members.find(@member.id))
    end

    def save_member
      @member.save
    end

    def user_groups
      @user.groups
    end

    def group_members
      if params[:group_member_search].present?
        Member::Search.new(@group.members, params[:group_member_search]).result
      else
        @group.members
      end
    end

    def non_group_members
      member_selection = @user.members.where.not(id: @group.members) 
      if params[:member_search].present?
        Member::Search.new(member_selection, params[:member_search]).result
      else
        member_selection 
      end
    end

    def all_members
      @user.members 
    end

end
