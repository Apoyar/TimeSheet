class Activity < ActiveRecord::Base
    #relationships
    belongs_to :project
    
    has_one :client, through: :project
    
    has_many :assignments, dependent: :destroy
    has_many :users, through: :assignments
    
    has_many :tasks, through: :assignments, dependent: :destroy
    #validations
    validates :project_id, presence: true
    validates_uniqueness_of :name, :scope => [:project_id]
end