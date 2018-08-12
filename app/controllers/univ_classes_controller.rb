class UnivClassesController < ApplicationController
    def index
        @user = User.find(params[:user_id])
        @univ_classes = 
            UnivClass
                .with_univ_class_details
        if params[:day].present? && params[:period].present?
            day = params[:day]=="All" ? ["月", "火", "水", "木", "金"] : params[:day]
            period = params[:period]=="All" ? ["1", "2", "3", "4", "5"] : params[:period]
            @univ_classes = UnivClass.with_same_day_and_period_without_user(day, period)
            day_index =  ["月", "火", "水", "木", "金", "All"].index(params[:day])
            @day = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "All Classes"][day_index]
            @period = period
        elsif params[:day].present?
            @univ_classes = UnivClass.with_same_day(params[:day])
            day_index =  ["月", "火", "水", "木", "金"].index(params[:day])
            @day = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"][day_index]
        else
            @univ_classes = UnivClass.all
            @day = "All Classes"
        end
    end
    
    def update
        @user = User.find(params[:user_id])
        @univ_class = UnivClass.find(params[:id])
        extreme = params[:extreme]
        if extreme == "1"
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
        @existing_classes = UnivClass.with_same_day_and_period_with_user(@user.id, @univ_class.univ_class_details.pluck(:day), @univ_class.univ_class_details.pluck(:period))
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
