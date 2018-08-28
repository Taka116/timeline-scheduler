class LikesController < ApplicationController
    before_action :set_user
    before_action :set_univ_class, only: [:create, :destroy]
    
    def show
        @likes = Like.where(user_id: @user.id)
    end

    def create
        @like = @user.likes.new(univ_class_id: @univ_class.id)
        @like.save!
        @user = @user.reload
        @univ_class = @univ_class.reload
    end
    
    def destroy
        @like = Like.find_by(user_id: @user.id, univ_class_id: @univ_class.id)
        @like.destroy
        @user = @user.reload
        @univ_class = @univ_class.reload
    end
    
    private
    
    def set_user
        @user = User.find(params[:user_id])
    end
    
    def set_univ_class
        @univ_class = UnivClass.find(params[:univ_class_id])
    end
end
