class PhotosController < ApplicationController
  def index
    matching_photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    public_users     = User.where({ :private => false })
    public_user_ids  = public_users.map { |u| u.id }
    matching_photos  = Photo.where({ :owner_id => public_user_ids })
    @list_of_photos  = matching_photos

    render({ :template => "photos/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

    matching_users = User.where({ :id => @the_photo.owner_id })
    @owner_user    = matching_users.at(0)

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
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully."} )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully."} )
  end
end
