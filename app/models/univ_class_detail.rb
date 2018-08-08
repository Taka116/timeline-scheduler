class UnivClassDetail < ApplicationRecord
    belongs_to :univ_class, optional: true
    
    scope :with_day, -> (day) { UnivClassDetail.where(day: day).order(:period)}
end
