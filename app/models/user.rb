class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable

  has_many :univ_classes, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  scope :with_univ_class_details, -> { includes(univ_classes: [:univ_class_details]) }
  
  validates :email, presence: true, uniqueness: true
  validates :nickname, presence: true, uniqueness: true
  validates :password, presence: true

    # Future::: デザインを揃える際に、同じ日、periodにあるレコードとそうじゃないやつを取得しなくてはいけない？？
    # def self.univ_class_with_same_day_and_period
    #     univ_class_details = UnivClass.where(user_id: user.id).map {|univ_class| univ_class.univ_class_details}
    #     univ_class_details.find()
    #     self.univ_classes.map do |univ_class|
    #         univ_class.univ_class_details
    #     end
    # end
    
end
