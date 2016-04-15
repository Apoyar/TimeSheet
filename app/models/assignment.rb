class Assignment < ActiveRecord::Base
    #relationships
    belongs_to :activity
    belongs_to :user
    
    has_many :tasks, dependent: :destroy
    has_one :project, through: :activity
    has_one :client, through: :activity
    
    
    #validations
    validates :user_id, presence: true
    validates :activity_id, presence: true
    validates_uniqueness_of :user_id, :scope => [:activity_id]
end