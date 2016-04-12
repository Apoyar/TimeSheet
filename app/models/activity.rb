class Activity < ActiveRecord::Base
    #relationships
    belongs_to :project
    has_many :tasks
    has_many :assignments
    has_many :users, through: :assignments
end