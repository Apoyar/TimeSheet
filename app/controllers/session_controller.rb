class SessionController < ApplicationController
    
    def new
        if current_user
            redirect_to root_path
        end
    end
    
    def create
        #create a new session 
        @user=User.find_by_handle(reference_params[:handle])
        if @user && @user.encrypted_password==BCrypt::Engine.hash_secret(reference_params[:password], @user.salt)
            session[:user_id]=@user.id
        end
        redirect_to root_path
    end
    
    def destroy
        reset_session
        redirect_to root_path
    end
    private
        # Never trust parameters from the scary internet, only allow the white list through.
        def reference_params
          params.require(:user).permit(:handle, :password)
        end
end
