class Client < ActiveRecord::Base
    #relationships
    has_many :projects
    
    validates_uniqueness_of :name
end