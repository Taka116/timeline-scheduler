class User < ApplicationRecord
    has_many :univ_classes, dependent: :destroy
    has_many :likes, dependent: :destroy
    
    scope :with_univ_class_details, -> { includes(univ_classes: [:univ_class_details]) }
    
    # Future::: デザインを揃える際に、同じ日、periodにあるレコードとそうじゃないやつを取得しなくてはいけない？？
    # def self.univ_class_with_same_day_and_period
    #     univ_class_details = UnivClass.where(user_id: user.id).map {|univ_class| univ_class.univ_class_details}
    #     univ_class_details.find()
    #     self.univ_classes.map do |univ_class|
    #         univ_class.univ_class_details
    #     end
    # end
    
end
