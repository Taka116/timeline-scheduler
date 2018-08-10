class UnivClassesController < ApplicationController
    def index
        @user = User.find(params[:user_id])
        @univ_classes = 
            UnivClass
                .with_univ_class_details
        @univ_classes_per_day = UnivClass.with_same_day(params[:day])
        day_index =  ["月", "火", "水", "木", "金"].index(params[:day])
        @day = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"][day_index]
    end
    
    def update
        @user = User.find(params[:user_id])
        @univ_class = UnivClass.find(params[:id])
        extreme = params[:extreme]
        if extreme == "1"
            byebug
            existing_classes = UnivClass.with_same_day_and_period(@user.id, @univ_class.univ_class_details.pluck(:day), @univ_class.univ_class_details.pluck(:period))
            existing_classes.update_all(user_id: nil)
            @univ_class.update(update_params)
            flash[:success] = "Successfully Added to Your Time Schedule"
            redirect_to user_path(@user)
        elsif extreme == "0"
            @univ_class.update(update_params)
            flash[:success] = "Successfully Added to Your Time Schedule"
            redirect_to user_path(@user)
        else
            flash[:error] = "Something Happened."
            render 'index'
        end
    end
    
    def show
        @user = User.find(params[:user_id])
        @univ_class = UnivClass.find(params[:id])
        @existing_classes = UnivClass.with_same_day_and_period(@user.id, @univ_class.univ_class_details.pluck(:day), @univ_class.univ_class_details.pluck(:period))
    end

    def destroy
        @user = User.find(params[:user_id])
        @univ_class = UnivClass.find(params[:id])
        if @univ_class.update(user_id: nil)
            flash[:success] = "Successfully Removed from Your Time Schedule"
            redirect_to user_path(@user)
        else
            flash[:error] = "Something Happened."
            render 'show'
        end
    end
    
    def import
        UnivClass.import(params[:file])
        redirect_to root_path, notice: 'Successfully imported #{params[:file]}'
    end
    
    def update_params
        params
            .permit(:id, :user_id)
    end
end
