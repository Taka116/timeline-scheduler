class UnivClassesController < ApplicationController
    def index
        @user = User.find(params[:user_id])
        @UnivClasses = 
            UnivClass
                .with_univ_class_details
    end
    
    def update
        @univ_class = UnivClass.find(params[:id])
        if @univ_class.update(update_params)
            flash[:success] = "Successfully Added to Your Time Schedule"
            redirect_to user_path
        else
            flash[:error] = "Something Happened."
            render 'index'
        end
    end
    
    def show
        @user = User.find(params[:user_id])
        @univ_class = UnivClass.find(params[:id])
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
