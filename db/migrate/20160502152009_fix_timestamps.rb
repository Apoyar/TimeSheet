class FixTimestamps < ActiveRecord::Migration
  def change  
    add_column(:clients, :created_at, :datetime, null: false, :default => Time.now)
    add_column(:clients, :updated_at, :datetime, null: false, :default => Time.now)
    
    add_column(:projects, :created_at, :datetime, null: false, :default => Time.now)
    add_column(:projects, :updated_at, :datetime, null: false, :default => Time.now)
    
    add_column(:activities, :created_at, :datetime, null: false, :default => Time.now)
    add_column(:activities, :updated_at, :datetime, null: false, :default => Time.now)
    
    add_column(:assignments, :created_at, :datetime, null: false, :default => Time.now)
    add_column(:assignments, :updated_at, :datetime, null: false, :default => Time.now)
  end
end