class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.string :str_field
      t.integer :int_field

      t.timestamps null: false
    end
  end
end
