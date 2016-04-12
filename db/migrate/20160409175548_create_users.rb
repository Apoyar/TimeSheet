class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      
      t.string :first_name
      t.string :last_name
      
      t.string :handle
      
      t.string :email
      t.string :whatsapp
      t.string :tel
      
      t.boolean :is_admin
      
      t.string :encrypted_password 
      t.string :salt
      
      t.timestamps null: false
    
    end
  end
end
