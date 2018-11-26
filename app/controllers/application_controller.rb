class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from Exception, with: :render_500

    def access_denied(*)
        redirect_to root_path
    end
    
    def after_sign_in_path_for(resource)
        user_univ_classes_path(current_user)
    end

    def after_sign_out_path_for(resource)
        root_path
    end
    
    def render_404
      render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
    end
    
    def render_500
      render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
    end
    
    private
    def authenticate_user!
        session[:redirect_path_after_login] = request.url
        super
    end
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[nickname])
    end
end
