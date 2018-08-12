class UnivClass < ApplicationRecord
    require 'csv'
    
    belongs_to :user, optional: true
    has_many :univ_class_details, dependent: :destroy
    
    validates :class_code, uniqueness: { scope: [:subject_name, :professor] }
    
    scope :with_univ_class_details, -> { includes(:univ_class_details) }
    scope :with_same_day, -> (day) { joins(:univ_class_details).merge( UnivClassDetail.with_day(day) )}
    scope :with_same_day_and_period_with_user, -> (user_id, days, periods) { UnivClass.where(user_id: user_id).joins(:univ_class_details).merge( UnivClassDetail.with_same_day_and_period(days, periods) ) }
    scope :with_same_day_and_period_without_user, -> (days, periods) { UnivClass.joins(:univ_class_details).merge( UnivClassDetail.with_same_day_and_period(days, periods) ) }

    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            univ_class = UnivClass.where(class_code: row["class_code"], subject_name: row["subject_name"], professor: row["professor"]).first
            if univ_class.nil?
                univ_class = UnivClass.create!(class_code: row["class_code"], subject_name: row["subject_name"], professor: row["professor"])
                univ_class.univ_class_details.create!(day: row["day"], period: row["period"].to_i, classroom: row["classroom"])
            else
                univ_class.univ_class_details.create!(day: row["day"], period: row["period"].to_i)
            end
        end
    end
end
