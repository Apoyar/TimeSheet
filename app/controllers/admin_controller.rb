class AdminController < ApplicationController
    before_action :check_admin
    
    def list_tasks
        @tasks = Task.all
    end
    
    #edit user details
    def user_edit
        @user=current_user
    end
    
    #update user
    def user_update
        @user=current_user
        @user.update(user_params)
        redirect_to '/admin/edit'
    end
    
    #change password
    def change_password
        @params=password_params
        @user=current_user
        if @params[:repeat]==@params[:new]
            @user.password=@params[:new]
            @user.password_verify=@params[:old]
            @user.change_password
            @user.save
        end
        redirect_to '/admin/edit'
    end
    
    private
    # Never trust parameters from the scary internet, only allow the white list through.
        def search_params
            params.require(:search).permit(:client, :project, :date, :activity, :user, :hours)
        end
        
        def user_params
            params.require(:user).permit(:handle, :first_name, :last_name, :tel, :whatsapp, :email)
        end
        
        def password_params
            params.require(:pass).permit(:old, :new, :repeat)
        end
end