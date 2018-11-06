class HomeController < ApplicationController
    layout 'home'

    def index
        render :index
    end
end
