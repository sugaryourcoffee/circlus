class EventsController < ApplicationController

  before_action :load_user_and_group

  def index
    load_events
  end

  def show
    load_event
  end

  def new
    build_event
  end

  def create
    build_event
    save_event or render :new
  end

  def edit
    load_event
  end

  def update
    load_event
    build_event
    save_event or render :edit
  end

  def destroy
    load_event
    @event.destroy
    redirect_to group_events_path @group
  end

  private

    def load_user_and_group
      @user ||= current_user
      @group ||= user_groups.find_by(id: params[:group_id])
    end

    def load_events
      @events ||= (@group ? group_events : user_events)
    end

    def load_event
      @event ||= group_events.find(params[:id])
    end

    def build_event
      @event ||= group_events.build
      @event.attributes = event_params
    end

    def save_event
      if @event.save
        redirect_to group_events_path @group
      end
    end

    def event_params
      event_params ||= params[:event]
      event_params ? event_params.permit(:title, :description, :cost,
                                         :information, 
                                         :departure_place, :arrival_place,
                                         :venue,
                                         :start_date, :start_time,
                                         :end_date, :end_time) : {}
    end

    def group_events
      @group.events
    end

    def user_events
      @user.events
    end

    def user_groups
      @user.groups
    end

end
