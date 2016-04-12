class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.belongs_to :client
      t.belongs_to :project
    end
  end
end
