require 'csv'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  private
    def check_admin
      if !current_user || !current_user.is_admin
        redirect_to root_path
      end
    end
    
    def check_user
      if !current_user || current_user.is_admin
        redirect_to root_path
      end
    end
    
    def current_user
      if session[:user_id] && session[:timeout]>=DateTime.now
        @current_user=User.find(session[:user_id])
      else
        @current_user=nil
      end
    end
    
    def iterate_add_tasks(obj)
      temp=nil
      obj.each do |o|
          if !temp.nil? && defined? o.tasks
            temp=temp+o.tasks.includes(:client, :project, :activity, :user)
          elsif defined? o.tasks && temp.nil?
            temp=o.tasks.includes(:client, :project, :activity, :user)
          end
      end
      return temp
    end
    
    def total_hours(tasks)
      if tasks
        total=0
        tasks.each do |task|
          total+=task.hours
        end
        return total
      end
    end
    
    def tasks_to_csv(tasks)
      CSV.generate do |csv|
        csv << ['Total Hours:', total_hours(tasks)]
        csv << ['User', 'Client', 'Project', 'Activity' 'Date', 'Hours', 'Notes']
        tasks.each do |task|
          csv << [task.user.handle, task.client.name, task.project.name, task.activity.name, task.date, task.hours, task.notes]
        end
      end
    end
end
