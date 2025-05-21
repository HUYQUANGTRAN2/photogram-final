class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })
  def index
    # grab IDs of all public users in one step
    public_ids     = User.where({ :private => false }).pluck(:id)
    
    # load only photos owned by those users, newest first
    @public_photos = Photo.where({ :owner_id => public_ids })
                          .order({ :created_at => :desc })

    render({ :template => "photos/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

    matching_comments = Comment.where({ :photo_id => @the_photo.id })
    @comments         = matching_comments

    matching_users = User.where({ :id => @the_photo.owner_id })
    @owner_user    = matching_users.at(0)

    matching_comments = Comment.where({ :photo_id => @the_photo.id })
    @comments         = matching_comments
    @comments_count   = matching_comments.count

    render({ :template => "photos/show" })
  end

  def create
    the_photo          = Photo.new
    the_photo.owner_id = current_user.id
    the_photo.caption  = params.fetch("caption")
    the_photo.image    = params.fetch("image")

    if the_photo.valid?
      the_photo.save
      redirect_to(
        "/photos",
        { :notice => "Photo created successfully." }
      )
    else
      redirect_to(
        "/photos",
        { :alert => the_photo.errors.full_messages.to_sentence }
      )
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{path_id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{path_id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end
