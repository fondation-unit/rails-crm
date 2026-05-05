module Searchable
  extend ActiveSupport::Concern

  def search_records(scope, policy = true)
    session[:search] = params[:q].presence || ""

    # p "*" * 90
    # p session[:search]
    # p "*" * 90

    records = params[:q].present? ? scope.search_ranked(params[:q]) : scope.all
    authorize records if policy

    records
  end
end
