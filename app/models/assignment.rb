class Assignment < ActiveRecord::Base
    #relationships
    has_many :user_assignments
    has_many :users, through: :user_assignments
    has_many :tasks
    belongs_to :activity
    belongs_to :project
    belongs_to :client
end