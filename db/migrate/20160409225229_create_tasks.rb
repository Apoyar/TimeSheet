class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :assignment
      t.float :hours
      t.date :date
      t.text :notes
    end
  end
end
