class Like < ApplicationRecord
    belongs_to :user
    belongs_to :univ_class
    
    validates :user_id, uniqueness: { scope: [:univ_class_id] }
end
