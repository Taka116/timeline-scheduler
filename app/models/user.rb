class User < ApplicationRecord
    has_many :univ_classes, dependent: :destroy
    
    # scope :with_univ_class_details, -> { includes(univ_classes: [univ_class_details]) }

end
