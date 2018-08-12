class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @univ_class_details = User.with_univ_class_details
        gon.user_id = User.find(params[:id]).id
        gon.user_univ_class_details = @user.univ_classes.map { |univ_class| univ_class.univ_class_details }
        gon.user_univ_classes = gon.user_univ_class_details.map { |detail| detail[0].univ_class}
    end
end
