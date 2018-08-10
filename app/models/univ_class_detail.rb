class UnivClassDetail < ApplicationRecord
    belongs_to :univ_class, optional: true
    
    scope :with_day, -> (day) { UnivClassDetail.where(day: day).order(:period)}
    scope :with_same_day_and_period, -> (days, periods) { UnivClassDetail.where(day: days, period: periods) }
end
