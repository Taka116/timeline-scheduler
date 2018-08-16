class UsersController < ApplicationController
    def show
        @user = User.find(params[:id])
        @univ_class_details = User.with_univ_class_details
        gon.user_id = User.find(params[:id]).id
        gon.user_univ_class_details = @user.univ_classes.collect { |univ_class| univ_class.univ_class_details }.flatten
        gon.user_univ_classes = gon.user_univ_class_details.map { |detail| detail.univ_class}
    end
end
