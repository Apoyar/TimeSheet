class Client < ActiveRecord::Base
    #relationships
    has_many :projects, dependent: :destroy
    
    has_many :tasks, through: :projects, dependent: :destroy
    has_many :assignments, through: :projects, dependent: :destroy
    has_many :activities, through: :projects, dependent: :destroy
    has_many :users, through: :projects
    
    
    validates_uniqueness_of :name
end