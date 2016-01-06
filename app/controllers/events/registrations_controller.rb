class Events::RegistrationsController < ApplicationController

  before_action :load_user_event_and_group

  def index
    load_registrations
    load_not_registered_group_members
  end

  def register
    load_member
    register_member
    redirect_to event_registrations_path @event
  end

  def confirm
    load_registration
    toggle_confirmed
    redirect_to event_registrations_path @event
  end

  def destroy 
    load_registration
    @registration.destroy
    redirect_to event_registrations_path @event
  end

  private

    def load_user_event_and_group
      @user ||= current_user
      @event ||= user_groups_events.find(params[:event_id] || params[:id])
      @group ||= @event.group
    end

    def load_not_registered_group_members
      @not_registered_group_members ||= not_registered_group_members
    end

    def load_registrations
      @registrations ||= event_registrations
    end

    def load_registration
      @registration ||= event_registrations.find(params[:id])
    end

    def toggle_confirmed
      @registration.toggle!(:confirmed)
    end

    def load_member
      @member ||= not_registered_group_members.find(params[:member_id])
    end

    def register_member
      @event.members << @member
    end

    def not_registered_group_members
      if params[:member_search].present?
        Member::Search.new(@group.members.where.not(id: @event.members), 
                           params[:member_search]).result
      else
        @group.members.where.not(id: @event.members) 
      end
    end

    def event_registrations
      if params[:registration_search].present?
        search = Member::Search.new(@event.members, 
                                    params[:registration_search])
        @event.registrations.joins(:member).where(member_id: search.result)
      else
        @event.registrations
      end
    end

    def user_groups_events
      @user.events
    end

end
