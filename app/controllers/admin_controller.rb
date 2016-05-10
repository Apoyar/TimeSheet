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
                    @tasks=Task.includes(:user, :client, :project, :activity).all
                    flash[:notice]='Listing all tasks'
                end
            end
        rescue
            @tasks=Task.includes(:user, :client, :project, :activity).order(:date).limit(20).reverse
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
        if params[:client_name]
            @clients=Client.includes([:users, :projects=>[:users, :activities=>[:assignments=>[:user, :tasks]]]]).find_by_name(params[:client_name])
        else
            
        end
        @users=User.all.order(:handle).entries
    end
    
    def edit_client
        if edit_c_params[:client_id]
            client=Client.find(edit_c_params[:client_id])
            client.update(name: edit_c_params[:name])
            flash[:notice]='Updated client: '+client.name
            return redirect_to '/admin/list_clients?client_name='+client.name
        elsif edit_c_params[:project_id]
            project=Project.find(edit_c_params[:project_id])
            project.update(name: edit_c_params[:name])
            flash[:notice]='Updated project: '+project.name
            return redirect_to request.referer + '#project'+project.id.to_s
        elsif edit_c_params[:activity_id]
            activity=Activity.find(edit_c_params[:activity_id])
            activity.update(name: edit_c_params[:name])
            flash[:notice]='Updated activity: '+activity.name
            return redirect_to request.referer + '#activity'+activity.id.to_s
        end
    end
    #controller for deleting clients/projects/activities
    def delete_client
        begin
            if c_delete_params[:client]
                name=Client.find(c_delete_params[:client]).name
                Client.find(c_delete_params[:client]).destroy
                flash[:notice]='Deleted client: '+name
                return redirect_to '/admin/list_clients'
            elsif c_delete_params[:project]
                name=Project.find(c_delete_params[:project]).name
                Project.find(c_delete_params[:project]).destroy
                flash[:notice]='Deleted project: '+name
                return redirect_to :back
            elsif c_delete_params[:activity]
                project=Activity.find(c_delete_params[:activity]).project.id
                name=Activity.find(c_delete_params[:activity]).name
                Activity.find(c_delete_params[:activity]).destroy
                flash[:notice]='Deleted activity: '+name
                return redirect_to request.referer + '#project'+project.to_s
            elsif c_delete_params[:assignment]
                activity=Assignment.find(c_delete_params[:assignment]).activity.id
                Assignment.find(c_delete_params[:assignment]).destroy
                flash[:notice]='Deleted assignment'
                return redirect_to request.referer + '#activity'+activity.to_s
            end
        rescue
            flash[:error]='There was an error'
            redirect_to :back
        end
    end
    
    #client management
    def list_users
        
        begin
            @params=search_params_user
            if search_params
                if !search_params_user[:handle].empty?
                    query = User.where('handle LIKE ?', "%#{search_params_user[:handle]}%")
                    if query
                        @users.nil? ? @users=query : @users=@users&query
                    end
                end
                if !search_params_user[:first_name].empty?
                    query = User.where('first_name LIKE ?', "%#{search_params_user[:first_name]}%")
                    if query
                        @users.nil? ? @users=query : @users=@users&query
                    end
                end
                if !search_params_user[:last_name].empty?
                    query = User.where('last_name LIKE ?', "%#{search_params_user[:last_name]}%")
                    if query
                        @users.nil? ? @users=query : @users=@users&query
                    end
                end
                if !search_params_user[:email].empty?
                    query = User.where('email LIKE ?', "%#{search_params_user[:email]}%")
                    if query
                        @users.nil? ? @users=query : @users=@users&query
                    end
                end
                if @users
                    @users=@users.uniq
                end
                
                flash[:notice]=nil
                
                all=true
                @params.each do |p|
                    if !p[1].empty?
                        all=false
                    end
                end
                
                if all
                    @users=User.all.includes({assignments: [:client, :project, :activity]}).order(:handle)
                    flash[:notice]='Listing all users'
                end
            end
        rescue
            @users=User.includes({assignments: [:client, :project, :activity]}).limit(20).reverse
            flash[:notice]='Listing the latest 20 users'
        end
    end
    
    #controller for creating clients/projects/activities
    def create_client
        begin
            if create_params[:client]
                
                Client.create(name: create_params[:client])
                flash[:notice]='Client: '+create_params[:client]+', created! '
                return redirect_to '/admin/list_clients'+'?client_name='+create_params[:client]
                
            elsif create_params[:project]
            
                Client.find(create_params[:parent_id]).projects.create(name: create_params[:project])
                flash[:notice]='Project: '+create_params[:project]+', created! '
                return redirect_to request.referer+'#project'+Project.find_by_name(create_params[:project]).id.to_s
                
            elsif create_params[:activity]
            
                Project.find(create_params[:parent_id]).activities.create(name: create_params[:activity])
                flash[:notice]='Activity: '+create_params[:activity]+', created! '
                return redirect_to request.referer+'#activity'+Activity.find_by_name(create_params[:activity]).id.to_s
                
            elsif create_params[:user_id]
                begin
                    Assignment.create!(user_id: create_params[:user_id], activity_id: create_params[:parent_id])
                    flash[:notice]='Assigned user '+User.find(create_params[:user_id]).handle+' to activity '+Activity.find(create_params[:parent_id]).name
                    return redirect_to request.referer+'#ass'+Assignment.where(user_id: create_params[:user_id], activity_id: create_params[:parent_id]).first.id.to_s
                rescue
                    flash[:error]='You can only assign a user once to to a particular activity'
                end
            elsif create_params[:project_wide]
                begin
                    Project.find(create_params[:parent_id]).activities.each do |activity|
                        Assignment.create!(user_id: create_params[:project_wide], activity_id: activity.id)
                        flash[:notice]='Assigned user '+User.find(create_params[:project_wide]).handle+' to all activities in project '+Project.find(create_params[:parent_id]).name
                    end
                    return redirect_to request.referer+'#project'+create_params[:parent_id].to_s
                rescue
                    flash[:error]='You can only assign a user once to to a particular activity'
                end
            elsif create_params[:client_wide]
                begin
                    Client.find(create_params[:parent_id]).activities.each do |activity|
                        Assignment.create!(user_id: create_params[:client_wide], activity_id: activity.id)
                    end
                    flash[:notice]='Assigned user '+User.find(create_params[:client_wide]).handle+' to all activities in client '+Client.find(create_params[:parent_id]).name
                    return redirect_to :back
                rescue
                    flash[:error]='You can only assign a user once to to a particular activity'
                end
            end
            return redirect_to :back
        rescue
            flash[:error]='There was an error'
            redirect_to :back
        end
    end
    def create_user
        begin
            temp=create_user_params
            temp.delete(:send_cred)
            user=User.create!(temp)
            if create_user_params[:permission]=='admin'
                user.is_admin=true
                user.save!
            end
            if create_user_params[:send_cred] && create_user_params[:email]
                UserMailer.new_notification(create_user_params[:email], user, create_user_params[:password]).deliver_now
            end
            flash[:notice]='User '+create_user_params[:handle]+' was successfully created'
            redirect_to :back
        rescue
            flash[:error]='Failed to create user, make sure your handle/email is unique and not shorter than 3 characters'
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
    
    def change_user
        begin
            user=User.find(change_user_params[:user_id])
            if change_user_params[:password]!=''
                user.password=change_user_params[:password]
                user.save!
            end
            if change_user_params[:permission]=='admin'
                user.is_admin=true
                user.save!
            end
            paramsedit=change_user_params
            paramsedit.delete(:password)
            paramsedit.delete(:user_id)
            user.update!(paramsedit)
            flash[:notice]='User '+paramsedit[:handle]+' was successfully created'
            redirect_to :back
        rescue
            flash[:error]='Failed to edit user'
            redirect_to :back
        end
    end
    
    private
    # Never trust parameters from the scary internet, only allow the white list through.
        def search_params_user
            params.require(:search).permit(:handle, :first_name, :last_name, :email)
        end
        def edit_c_params
            params.require(:edit).permit(:client_id, :project_id, :activity_id, :name)
        end
        def change_user_params
            params.require(:user).permit(:handle, :email, :password, :first_name, :last_name, :tel, :whatsapp, :permission, :user_id)
        end
        
        def delete_user_params
            params.require(:user_id)
        end
        
        def create_user_params
            params.require(:user).permit(:handle, :password, :is_admin, :email, :send_cred, :first_name, :last_name, :tel, :whatsapp, :permission)
        end
        def create_params
            params.require(:create).permit(:client_wide, :project_wide, :client, :project, :activity, :parent_id, :user_id)
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