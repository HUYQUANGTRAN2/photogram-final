Rails.application.routes.draw do

  # Routes for the User resource:
  get("/users/edit",{ :controller => "users", :action => "edit" })
  post("/users/edit",{ :controller => "users", :action => "update" })
  devise_for :users
  get("/users",  {:controller => "users", :action => "index" })
  get("/users/:username",  {:controller => "users", :action => "show" })
  get(
  "/users/:username/feed",
  { :controller => "users", :action => "feed" }
)

  # Routes for the Follow request resource:

  # CREATE
  post("/insert_follow_request", { :controller => "follow_requests", :action => "create" })
          
  # READ
  get("/follow_requests", { :controller => "follow_requests", :action => "index" })
  
  get("/follow_requests/:path_id", { :controller => "follow_requests", :action => "show" })
  post(
  "/follow_requests",
  { :controller => "follow_requests", :action => "create" }
)
  
  # UPDATE
  
  post("/modify_follow_request/:path_id", { :controller => "follow_requests", :action => "update" })
  
  # DELETE
  get("/delete_follow_request/:path_id", { :controller => "follow_requests", :action => "destroy" })

  #------------------------------

  # Routes for the Like resource:

  # CREATE
  post("/likes", { :controller => "likes", :action => "create" })
          
  # READ
  get("/likes", { :controller => "likes", :action => "index" })
  
  get("/likes/:path_id", { :controller => "likes", :action => "show" })
  
  # UPDATE
  
  post("/modify_like/:path_id", { :controller => "likes", :action => "update" })
  
  # DELETE
  get(
    "/unlike/:path_id",
    { :controller => "likes", :action => "destroy" }
  )

  #------------------------------

  # Routes for the Comment resource:

  # CREATE
  post(
    "/comments",
    { :controller => "comments", :action => "create" }
  )
          
  # READ
  get("/comments", { :controller => "comments", :action => "index" })
  
  get("/comments/:path_id", { :controller => "comments", :action => "show" })
  
  # UPDATE
  
  post("/modify_comment/:path_id", { :controller => "comments", :action => "update" })
  
  # DELETE
  get("/delete_comment/:path_id", { :controller => "comments", :action => "destroy" })

  #------------------------------

  # Routes for the Photo resource:
  
  # CREATE
  post("/insert_photo", { :controller => "photos", :action => "create" })
          
  # READ
  get("/photos", { :controller => "photos", :action => "index" })
  post(
  "/photos",
  { :controller => "photos", :action => "create" }
)

  get("/photos/:path_id", { :controller => "photos", :action => "show" })
  
  # UPDATE
  
  post("/modify_photo/:path_id", { :controller => "photos", :action => "update" })
  
  # DELETE
  get("/delete_photo/:path_id", { :controller => "photos", :action => "destroy" })

  #------------------------------

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get("/", { :controller => "pages", :action => "home" }) 

end
