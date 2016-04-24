class AdminController < ApplicationController
    before_action :check_admin
    #main list tasks action
    def list_tasks
        begin
            @params=search_params
            if search_params
                if !search_params[:user].empty?
                    query = iterate_add_tasks(User.where('handle LIKE ?', "%#{search_params[:user]}%"))
                    if query
                        @tasks.nil? ? @tasks=query : @tasks=@tasks&query
                    end
                end
                if !search_params[:client].empty?
                    query = iterate_add_tasks(Client.where('name LIKE ?', "%#{search_params[:client]}%"))
                    if query
                        @tasks.nil? ? @tasks=query : @tasks=@tasks&query
                    end
                end
                if !search_params[:project].empty?
                    query = iterate_add_tasks(Project.where('name LIKE ?', "%#{search_params[:project]}%"))
                    if query
                        @tasks.nil? ? @tasks=query : @tasks=@tasks&query
                    end
                end
                if !search_params[:activity].empty?
                    query = iterate_add_tasks(Activity.where('name LIKE ?', "%#{search_params[:activity]}%"))
                    if query
                        @tasks.nil? ? @tasks=query : @tasks=@tasks&query
                    end
                end
                if @tasks
                    @tasks=@tasks.uniq
                end
                
                flash[:notice]=nil
                
                all=true
                @params.each do |p|
                    if !p[1].empty?
                        all=false
                    end
                end
                
                if all
                    @tasks=Task.all
                    flash[:notice]='Listing all tasks'
                end
            end
        rescue
            @tasks=Task.order(:date).limit(20).reverse
            flash[:notice]='Listing the latest 20 tasks'
        end
        @hours=total_hours(@tasks)
        respond_to do |format|
            format.html
            format.csv {send_data tasks_to_csv(@tasks)}
        end
    end
    
    #delete_task
    def delete_task
        Task.find(delete_params).destroy
        redirect_to :back
    end
    def edit_task
        Task.find(edit_params[:id]).update(edit_params)
        redirect_to :back
    end
    
    #edit user details
    def user_edit
        @user=current_user
    end
    
    #update user
    def user_update
        begin
            @user=current_user
            @user.update!(user_params)
            flash[:notice]='Your details have been updated'
            redirect_to '/admin/edit'
        rescue
            flash[:error]='Please make sure to fill out the form correctly'
            redirect_to '/admin/edit'
        end
    end
    
    #change password
    def change_password
        begin
            @params=password_params
            @user=current_user
            if @params[:repeat]==@params[:new]
                @user.password=@params[:new]
                @user.password_verify=@params[:old]
                @user.change_password
                @user.save!
                flash[:notice]='Password changed successfully'
            else
                flash[:error]='You didnt correctly retype your new password'
            end
            redirect_to '/admin/edit'
        rescue
            flash[:error]='Your old password wasn\'t correct'
            redirect_to '/admin/edit'
        end
    end
    
    #client management
    def list_clients
        @clients=Client.all.order(:name)
        @users=User.all.order(:handle)
    end
    def edit_client
    end
    #controller for deleting clients/projects/activities
    def delete_client
        begin
            if c_delete_params[:client]
                name=Client.find(c_delete_params[:client]).name
                Client.find(c_delete_params[:client]).destroy
                flash[:notice]='Deleted client: '+name
            elsif c_delete_params[:project]
                name=Project.find(c_delete_params[:project]).name
                Project.find(c_delete_params[:project]).destroy
                flash[:notice]='Deleted project: '+name
            elsif c_delete_params[:activity]
                name=Activity.find(c_delete_params[:activity]).name
                Activity.find(c_delete_params[:activity]).destroy
                flash[:notice]='Deleted activity: '+name
            elsif c_delete_params[:assignment]
                Assignment.find(c_delete_params[:assignment]).destroy
                flash[:notice]='Deleted assignment'
            end
            redirect_to :back
        rescue
            flash[:error]='There was an error'
            redirect_to :back
        end
    end
    
    #client management
    def list_users
        @users=User.all.order(:handle)
    end
    
    #controller for creating clients/projects/activities
    def create_client
        begin
            if create_params[:client]
                
                Client.create(name: create_params[:client])
                flash[:notice]='Client: '+create_params[:client]+', created! '
                
            elsif create_params[:project]
            
                Client.find(create_params[:parent_id]).projects.create(name: create_params[:project])
                flash[:notice]='Project: '+create_params[:project]+', created! '
                
            elsif create_params[:activity]
            
                Project.find(create_params[:parent_id]).activities.create(name: create_params[:activity])
                flash[:notice]='Activity: '+create_params[:activity]+', created! '
                
            elsif create_params[:user_id]
                begin
                    Assignment.create!(user_id: create_params[:user_id], activity_id: create_params[:parent_id])
                    flash[:notice]='Assigned user '+User.find(create_params[:user_id]).handle+' to activity '+Activity.find(create_params[:parent_id]).name
                rescue
                    flash[:error]='You can only assign a user once to to a particular activity'
                end
            elsif create_params[:project_wide]
                begin
                    Project.find(create_params[:parent_id]).activities.each do |activity|
                        Assignment.create!(user_id: create_params[:project_wide], activity_id: activity.id)
                        flash[:notice]='Assigned user '+User.find(create_params[:project_wide]).handle+' to all activities in project:'+Project.find(create_params[:parent_id]).name
                    end
                rescue
                    flash[:error]='You can only assign a user once to to a particular activity'
                end
            end
            redirect_to :back
        rescue
            flash[:error]='There was an error'
            redirect_to :back
        end
    end
    def create_user
        begin
            User.create!(create_user_params)
            flash[:notice]='User '+create_user_params[:handle]+' was successfully created'
            redirect_to :back
        rescue
            flash[:error]='Failed to create user, make sure your handle is unique and not shorter than 3 characters'
            redirect_to :back
        end
    end
    
    def delete_user
        begin
            user=User.find(delete_user_params).handle
            User.find(delete_user_params).destroy
            flash[:notice]='User '+user+' has been destroyed'
            redirect_to :back
        rescue
            flash[:error]='Something went horribly wrong'
            redirect_to :back
        end
    end
    
    def change_password_mass
        begin
            user=User.find(change_pass_params[:id])
            user.password=change_pass_params[:pass]
            user.save
            flash[:notice]='Password has been changed'
            redirect_to :back
        rescue
            flash[:error]='Something went horribly wrong'
            redirect_to :back
        end
    end
    
    def change_user
        begin
            para=change_user_params
            user=User.find(para[:id])
            if para[:is_admin].blank?
                para[:is_admin]=false
            end
            user.update!(para)
            flash[:notice]='User '+user.handle+' has been updated'
            redirect_to :back
        rescue
            flash[:error]='Something went horribly wrong'
            redirect_to :back
        end
    end
    private
    # Never trust parameters from the scary internet, only allow the white list through.
        def change_user_params
            params.require(:user).permit(:handle, :email, :first_name, :last_name, :email, :tel, :whatsapp, :id, :is_admin)
        end
        
        def change_pass_params
            params.require(:pass).permit(:pass, :id)
        end
        
        def delete_user_params
            params.require(:user_id)
        end
        
        def create_user_params
            params.require(:user).permit(:handle, :password, :is_admin, )
        end
        def create_params
            params.require(:create).permit(:project_wide, :client, :project, :activity, :parent_id, :user_id)
        end
        
        def c_delete_params
            params.require(:delete).permit(:client, :project, :activity, :assignment)
        end
        
        def edit_params
            params.require(:task).permit(:id, :hours, :date, :notes)
        end
        
        def delete_params
            params.require(:task_id)
        end
    
        def search_params
            params.require(:search).permit(:client, :project, :activity, :user)
        end
        
        def sort_params
            params.require(:sort)
        end
        
        def user_params
            params.require(:user).permit(:handle, :first_name, :last_name, :tel, :whatsapp, :email)
        end
        
        def password_params
            params.require(:pass).permit(:old, :new, :repeat)
        end
end