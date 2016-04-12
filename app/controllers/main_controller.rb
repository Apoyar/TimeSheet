class MainController < ApplicationController
    def main
        #redirect if user is already logged in
        if !current_user
            redirect_to '/login'
        elsif !current_user.is_admin
            redirect_to '/user/new_entry'
        elsif current_user.is_admin
            redirect_to '/admin/list_tasks'
        end
    end
end