class UserController < ApplicationController
    before_action :check_user
    
    def new_task
        @user=current_user
    end
    def get_projects
        @params=task_params
        @temp=current_user.assignments.where(@params)
        @counter=0
        @temp.each do |t|
            @res[@counter]={
                project_id: t.project.id, 
                name: t.project.name
            }
            @counter+=1
        end
        respond_to do |format|
            format.json {render json: @res}
        end
    end
    private
        # Never trust parameters from the scary internet, only allow the white list through.
        def task_params
          params.require(:task).permit(:client_id, :project_id)
        end
end