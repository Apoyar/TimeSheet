class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :user
      t.belongs_to :activity
    end
  end
end
