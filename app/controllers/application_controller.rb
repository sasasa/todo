class ApplicationController < ActionController::Base
  before_action :detect_locale

  def after_sign_in_path_for(resource)
    if current_user
      tasks_path
    else
      users_path
    end
  end

  def default_url_options(options = {})
    {locale: I18n.locale}.merge options
  end

  def t(key, options={})
    if key[0] == '.'
      key = controller_name + "_controller." + action_name + key
    end
    super
  end
  
  private
    def detect_locale
      I18n.locale = params[:locale] ||
        (request.headers['Accept-Language'] && 
         request.headers['Accept-Language'].scan(/\A[a-z]{2}/).first) ||
        I18n.default_locale
    end
end
