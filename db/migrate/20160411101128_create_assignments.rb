class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.belongs_to :client
      t.belongs_to :project
      t.belongs_to :activity
    end
  end
end
