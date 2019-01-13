class ShareController < ApplicationController
  skip_before_action :verify_authenticity_token,:only => [:change]

  # def change
  #   image =
  # end

end
