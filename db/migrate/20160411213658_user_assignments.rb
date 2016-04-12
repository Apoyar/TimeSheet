class UserAssignments < ActiveRecord::Migration
  def change
    create_table :user_assignments do |t|
      t.belongs_to :user
      t.belongs_to :assignment
    end
  end
end
