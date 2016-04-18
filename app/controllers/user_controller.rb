class UserController < ApplicationController
    before_action :check_user
    
    #landing page for users
    def new_task
        @clients=current_user.clients.uniq
    end
    
    #ajax for the main user page
    def get_projects
        @params=task_params
        @client=current_user.clients.find(@params[:client_id])
        counter=0
        @res=[]
        @client.projects.each do |c|
            if c.users.include? current_user
                @res[counter]={
                    project_id: c.id, 
                    name: c.name
                }
                counter+=1
            end
        end
        respond_to do |format|
            format.json {render json: @res.uniq}
        end
    end
    
    #ajax for the main user page
    def get_activities
        @params=task_params
        @project=current_user.projects.find(@params[:project_id])
        counter=0
        @res=[]
        @project.activities.each do |p|
            if p.users.include? current_user
                @res[counter]={
                    activity_id: p.id, 
                    name: p.name
                }
                counter+=1
            end
        end
        respond_to do |format|
            format.json {render json: @res.uniq}
        end
    end
    
    #list all tasks
    def history
        @tasks=current_user.tasks
    end
    
    #create a new task
    def create_task
        @p=task_params
        if !@p[:activity_id] || !@p[:project_id]
            flash[:error]='Please make sure to fill out the form correctly'
            return redirect_to action:'new_task'
        end
        @activity=Activity.find(@p[:activity_id])
        @c=current_user
        if !@activity.users.include? @c
            flash[:error]='Please make sure to fill out the form correctly'
            return redirect_to action:'new_task'
        end
        @ass=@activity.assignments.find_by_user_id(@c.id)
        @ass.tasks.create(
            hours: @p[:hours],
            notes: @p[:notes],
            date: @p[:date]
        )
        flash[:notice]='Task has been submitted'
        redirect_to '/user/new_entry'
    end
    
    #edit user details
    def user_edit
        @user=current_user
    end
    
    def user_update
        begin
            @user=current_user
            @user.update!(user_params)
            flash[:notice]='Your details have been updated'
            redirect_to '/user/edit'
        rescue
            flash[:error]='Please make sure to fill out the form correctly'
            redirect_to '/user/edit'
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
            redirect_to '/user/edit'
        rescue
            flash[:error]='Your old password wasn\'t correct'
            redirect_to '/user/edit'
        end
    end
    private
     # Never trust parameters from the scary internet, only allow the white list through.
        def user_params
            params.require(:user).permit(:first_name, :last_name, :tel, :whatsapp, :email)
        end
        
        def password_params
            params.require(:pass).permit(:old, :new, :repeat)
        end
      
        def task_params
            params.require(:task).permit(:client_id, :project_id, :activity_id, :hours, :notes, :date)
        end
end