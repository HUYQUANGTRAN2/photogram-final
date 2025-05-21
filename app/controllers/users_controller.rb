class UsersController < ApplicationController
  def index
    matching_user = User.all

    @list_of_users = matching_user.order({ :created_at => :desc })

    render({ :template => "users/index" })
  end

  def show
    the_username = params.fetch("username")

    matching_users = User.where({ :username => the_username })

    @the_user = matching_users.at(0)
    
    pending_requests = FollowRequest.where({
      :recipient_id => @the_user.id,
      :status       => "pending"
    })
    @pending_follow_requests = pending_requests

    render({ :template => "users/show" })
  end
end
