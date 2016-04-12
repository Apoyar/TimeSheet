class Project < ActiveRecord::Base
    #relationships
    belongs_to :client
    has_many :activities
    
    validates_uniqueness_of :name, :scope => [:client_id]
end