class User < ApplicationRecord
    has_many :univ_classes, dependent: :destroy
end
