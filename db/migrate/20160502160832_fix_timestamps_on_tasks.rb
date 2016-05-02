class FixTimestampsOnTasks < ActiveRecord::Migration
  def change
    add_column(:tasks, :created_at, :datetime, null: false, :default => Time.now)
    add_column(:tasks, :updated_at, :datetime, null: false, :default => Time.now)
  end
end
