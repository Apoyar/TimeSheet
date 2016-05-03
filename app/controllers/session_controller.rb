class SessionController < ApplicationController
    
    before_action :check_cred, except: :destroy
    
    def check_cred
        if current_user
            redirect_to root_path
        end
    end
    def new
        
    end
    
    def create
        #create a new session 
        @user=User.find_by_handle(reference_params[:handle])
        if @user && @user.encrypted_password==BCrypt::Engine.hash_secret(reference_params[:password], @user.salt)
            session[:user_id]=@user.id
        else
            flash[:error]='Incorect username or password'
        end
        
        redirect_to root_path
    end
    
    def destroy
        reset_session
        redirect_to root_path
    end
    def forgot_password
        
    end
    def reset_password
        user=User.find_by_email(reset_params)
        if user
            password=Faker::Internet.password(8)
            user.password=password
            user.save!
            flash[:notice]='We have sent you an email with instructions to reset your password'
            UserMailer.reset_email(reset_params, user, password).deliver_now
            redirect_to :back
        else
            flash[:error]='Sorry no user with such email was found'
            redirect_to :back
        end
    end
    private
        # Never trust parameters from the scary internet, only allow the white list through.
        def reference_params
          params.require(:user).permit(:handle, :password)
        end
        
        def reset_params
            params.require(:email)
        end
end
