Rails.application.routes.draw do
  #MAIN CONTROLLER
  root 'main#main'
  
  #AUTH STUFF
  get 'login' => 'session#new'
  post 'login' => 'session#create'
  get 'logout' => 'session#destroy'
  
  #USER STUFF
  get 'user/new_entry' => 'user#new_task'
  
  post 'user/ajax/get_projects' => 'user#get_projects'
  post 'user/ajax/get_activities' => 'user#get_activities'
  
  post 'user/create_entry' => 'user#create_task'
  
  get 'user/history' => 'user#history'
  
  get 'user/edit' => 'user#user_edit'
  post 'user/update' => 'user#user_update'
  post 'user/change_password' => 'user#change_password'
  
  #ADMIN STUFF
  get 'admin/list_tasks' => 'admin#list_tasks'
  post 'admin/delete_task' => 'admin#delete_task'
  post 'admin/edit_task' => 'admin#edit_task'
  
  get 'admin/edit' => 'admin#user_edit'
  post 'admin/update' => 'admin#user_update'
  post 'admin/change_password' => 'admin#change_password'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
