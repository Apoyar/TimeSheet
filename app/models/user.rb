class User < ActiveRecord::Base
    
    #relationships
    has_many :tasks, through: :assignments
    has_many :assignments
    has_many :activities, through: :assignments

    #variables for storing temp data
    attr_accessor :password, :password_verify
    
    #callbacks
    before_save :encrypt_password
    after_save :clear_password
    
    #method which runs before the user is saved/updated/created
    def change_password
        #check if user is new or being updated
        if self.encrypted_password.present?
            #verifies password
            if self.password_check
                self.encrypt_password
            end
        end
    end
    
    #clears password from memory after creation
    def clear_password
        self.password = nil
        self.password_verify = nil
    end
    
    #encrypts and salts password
    def encrypt_password
        if self.password.present?
            self.salt = BCrypt::Engine.generate_salt
            self.encrypted_password = BCrypt::Engine.hash_secret(self.password, salt)
        end
    end
    
    #check pasword for editing
    def password_check
        return self.encrypted_password==BCrypt::Engine.hash_secret(self.password_verify, self.salt)
    end
end