module Crm
  class ApplicationController < ::ApplicationController
    helper Crm::FilterHelper

    def index
      render 'crm/dashboard/index'
    end
  end
end
