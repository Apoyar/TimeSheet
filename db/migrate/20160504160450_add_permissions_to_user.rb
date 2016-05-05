class AddPermissionsToUser < ActiveRecord::Migration
  def change
    add_column(:users, :permission, :string, :default => 'default')
  end
end
