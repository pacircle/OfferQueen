class ApplicationController < ActionController::Base
  after_action :access_control_headers

  def access_control_headers
    headers['Access-Control-Allow-Origin'] = "*" # or your web site like http://localhost:4200
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
  end

end
