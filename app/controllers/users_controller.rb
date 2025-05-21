class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  def index
    matching_user = User.all

    @list_of_users = matching_user.order({ :created_at => :desc })

    render({ :template => "users/index" })
  end

  def show
    the_username = params.fetch("username")

    matching_users = User.where({ :username => the_username })

    @the_user = matching_users.at(0)
    
    @photos = Photo.where({ :owner_id => @the_user.id })

    pending_requests = FollowRequest.where({
      :recipient_id => @the_user.id,
      :status       => "pending"
    })
    @pending_follow_requests = pending_requests

    accepted_followers = FollowRequest.where({
    :recipient_id => @the_user.id,
    :status       => "accepted"
  })
  @follower_count = accepted_followers.count

  accepted_following = FollowRequest.where({
      :sender_id => @the_user.id,
      :status    => "accepted"
    })
  @following_count = accepted_following.count  

    render({ :template => "users/show" })
  end
  
  def edit
    render({ :template => "users/edit" })
  end
  
  def feed
    the_username   = params.fetch("username")
    matching_users = User.where({ :username => the_username })
    @the_user      = matching_users.at(0)

    # find all accepted follow‐requests where this user is the sender
    accepted = FollowRequest.where({
      :sender_id => @the_user.id,
      :status    => "accepted"
    })

    # pull out the IDs of everyone they follow
    followed_ids = accepted.map { |fr| fr.recipient_id }

    # load only the photos owned by those followed users
    @photos = Photo.where({ :owner_id => followed_ids })

    render({ :template => "users/feed" })
  end

  def update
    the_user = current_user
    the_user.username = params.fetch("username")
    # we require current_password in the form but do not verify it here

    if the_user.valid?
      the_user.save
      redirect_to("/", { :notice => "Profile updated successfully." })
    else
      redirect_to("/users/edit", { :alert => the_user.errors.full_messages.to_sentence })
    end
  end
end
