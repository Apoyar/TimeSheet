class Project < ActiveRecord::Base
    #relationships
    belongs_to :client
    has_many :activities
    
    has_many :tasks, through: :activities
    has_many :assignments, through: :activities
    has_many :users, through: :activities
    
    
    validates_uniqueness_of :name, :scope => [:client_id]
end