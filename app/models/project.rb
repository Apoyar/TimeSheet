class Project < ActiveRecord::Base
    #relationships
    belongs_to :client
    has_many :activities
end