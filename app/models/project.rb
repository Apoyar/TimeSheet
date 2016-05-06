class Project < ActiveRecord::Base
    #relationships
    belongs_to :client
    has_many :activities, dependent: :destroy
    
    has_many :tasks, through: :activities, dependent: :destroy
    has_many :assignments, through: :activities, dependent: :destroy
    has_many :users, through: :activities
    
    
    validates_uniqueness_of :name, :scope => [:client_id]
end