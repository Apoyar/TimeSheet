class Client < ActiveRecord::Base
    #relationships
    has_many :projects
    
    has_many :tasks, through: :projects
    has_many :assignments, through: :projects
    has_many :users, through: :projects
    has_many :activities, through: :projects
    
    validates_uniqueness_of :name
end