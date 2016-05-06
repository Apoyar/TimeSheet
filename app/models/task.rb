class Task < ActiveRecord::Base
    #relationships
    belongs_to :assignment
    has_one :activity, through: :assignment
    has_one :user, through: :assignment
    has_one :client, through: :assignment
    has_one :project, through: :assignment
    #validations
    validates :assignment_id, presence: true
    validates :hours, presence: true
    validates :date, presence: true
    #utility
 
end