class Client < ActiveRecord::Base
    #relationships
    has_many :projects
end