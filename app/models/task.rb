class Task < ActiveRecord::Base
    #relationships
    belongs_to :assignment
    #validations
    validates :hours, presence: true
    validates :assignment_id, presence: true
    validates :date, presence: true
end