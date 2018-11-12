class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
    before_action :set_univ_class, only: [:create, :destroy]
    
    def show
        likes = Like.where(user_id: @user.id)
        @univ_classes = likes.map(&:univ_class)
    end

    def create
        @like = @user.likes.new(univ_class_id: @univ_class.id)
        if @like.save
            @user = @user.reload
            @univ_class = @univ_class.reload
            render :create, format: "js"
        else
            render json: { errors: @like.errors }, status: :unprocessable_entity
        end
    end
    
    def destroy
        @like = Like.find_by(user_id: @user.id, univ_class_id: @univ_class.id)
        respond_to do |format|
            if @like.destroy
                likes = Like.where(user_id: @user.id)
                @user = @user.reload
                likes = Like.where(user_id: @user.id)
                @univ_classes = likes.map(&:univ_class)
                @univ_class = @univ_class.reload
                format.html { render :show }
                format.js { render :destroy }
            else
                render json: { errors: @like.errors }, status: :unprocessable_entity
            end
        end
    end
    
    private
    
    def set_user
        @user = User.find(params[:user_id])
    end
    
    def set_univ_class
        @univ_class = UnivClass.find(params[:univ_class_id])
    end
end
