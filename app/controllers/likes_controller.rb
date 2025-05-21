class LikesController < ApplicationController
  def index
    matching_likes = Like.all

    @list_of_likes = matching_likes.order({ :created_at => :desc })

    render({ :template => "likes/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_likes = Like.where({ :id => the_id })

    @the_like = matching_likes.at(0)

    render({ :template => "likes/show" })
  end


  def create
    # grab only the photo_id that your form sends
    photo_id = params.fetch("photo_id")

    new_like = Like.new
    # don’t trust the form for fan_id—use the signed-in user
    new_like.fan_id   = current_user.id
    new_like.photo_id = photo_id

    if new_like.valid?
      new_like.save
      redirect_to(
        "/photos/#{photo_id}",
        { :notice => "Like created successfully." }
      )
    else
      redirect_to(
        "/photos/#{photo_id}",
        { :alert => new_like.errors.full_messages.to_sentence }
      )
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_like = Like.where({ :id => the_id }).at(0)

    the_like.fan_id = params.fetch("query_fan_id")
    the_like.photo_id = params.fetch("query_photo_id")

    if the_like.valid?
      the_like.save
      redirect_to("/likes/#{the_like.id}", { :notice => "Like updated successfully."} )
    else
      redirect_to("/likes/#{the_like.id}", { :alert => the_like.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id        = params.fetch("path_id")
    matching_likes = Like.where({ :id => the_id })
    the_like       = matching_likes.at(0)

    if the_like.nil?
      redirect_to(
        "/photos",
        { :alert => "Like not found." }
      )
      return
     end
    
    photo_id = the_like.photo_id
    the_like.destroy

    redirect_to(
      "/",
      { :notice => "Like removed successfully." }
    )
  end
end 
