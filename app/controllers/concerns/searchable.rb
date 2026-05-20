module Searchable
  extend ActiveSupport::Concern

  def search_records(scope, policy = true)
    session[:search] = params[:q].presence || ""

    records = params[:q].present? ? scope.search_ranked(params[:q]) : scope.all
    #authorize records if policy
#
    records
  end
end
