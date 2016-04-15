class AdminController < ApplicationController
    before_action :check_admin
    
    def list_tasks
        begin
            @params=search_params
            if search_params
                if !search_params[:user].empty?
                    query = iterate_add_tasks(User.where('handle LIKE ?', "%#{search_params[:user]}%"))
                    @tasks.nil? ? @tasks=query : @tasks=@tasks&query
                end
                if !search_params[:client].empty?
                    query = iterate_add_tasks(Client.where('name LIKE ?', "%#{search_params[:client]}%"))
                    @tasks.nil? ? @tasks=query : @tasks=@tasks&query
                end
                if !search_params[:project].empty?
                    query = iterate_add_tasks(Project.where('name LIKE ?', "%#{search_params[:project]}%"))
                    @tasks.nil? ? @tasks=query : @tasks=@tasks&query
                end
                if !search_params[:activity].empty?
                    query = iterate_add_tasks(Activity.where('name LIKE ?', "%#{search_params[:activity]}%"))
                    @tasks.nil? ? @tasks=query : @tasks=@tasks&query
                end
                flash[:notice]=nil
                
                @params.each do |p|
                    all=true
                    if !p.empty?
                        all=false
                    end
                end
                
                if all
                    @tasks=Task.all
                    flash[:notice]='Listing all tasks'
                end
                @tasks=@tasks.uniq
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
        Task.find(delete_params).delete
        redirect_to '/admin/list_tasks'
    end
    def edit_task
        Task.find(edit_params[:id]).update(edit_params)
        redirect_to '/admin/list_tasks'
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
    
    #user management
    def list_users
    end
    
    private
    # Never trust parameters from the scary internet, only allow the white list through.
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