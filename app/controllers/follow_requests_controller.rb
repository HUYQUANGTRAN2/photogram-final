class FollowRequestsController < ApplicationController
  def index
    matching_follow_requests = FollowRequest.all

    @list_of_follow_requests = matching_follow_requests.order({ :created_at => :desc })

    render({ :template => "follow_requests/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_follow_requests = FollowRequest.where({ :id => the_id })

    @the_follow_request = matching_follow_requests.at(0)

    render({ :template => "follow_requests/show" })
  end

  def create
  
    recipient_id = params.fetch("recipient_id")

    
    recipient = User.where({ :id => recipient_id }).at(0)

    the_follow_request = FollowRequest.new
    the_follow_request.sender_id    = current_user.id
    the_follow_request.recipient_id = recipient_id
    if recipient.private?
      the_follow_request.status = "pending"
    else
      the_follow_request.status = "accepted"
    end

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/follow_requests", { :notice => "Follow request created successfully." })
    else
      redirect_to("/follow_requests", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end

  end

  def update
    the_id = params.fetch("path_id")
    the_follow_request = FollowRequest.where({ :id => the_id }).at(0)

    the_follow_request.recipient_id = params.fetch("query_recipient_id")
    the_follow_request.sender_id = params.fetch("query_sender_id")
    the_follow_request.status = params.fetch("query_status")

    if the_follow_request.valid?
      the_follow_request.save
      redirect_to("/follow_requests/#{the_follow_request.id}", { :notice => "Follow request updated successfully."} )
    else
      redirect_to("/follow_requests/#{the_follow_request.id}", { :alert => the_follow_request.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id             = params.fetch("path_id")
    matching_requests  = FollowRequest.where({ :id => the_id })
    the_follow_request = matching_requests.at(0)

    # stash the recipient_id before we destroy
    recipient_id = the_follow_request.recipient_id

    the_follow_request.destroy

    # look up the recipient User by id
    matching_users = User.where({ :id => recipient_id })
    the_recipient  = matching_users.at(0)
    
    the_follow_request.destroy
    
    redirect_to(
      "/users/#{the_recipient.username}",
      { :notice => "Unfollowed successfully." }
    )
  end
end
