module Crm
module Searchable
  extend ActiveSupport::Concern

  def search_records(scope, policy = true)
    session[:search] = params[:q].to_s if params.key?(:q)

    query = session[:search].to_s

    return scope.all if query.blank?

    scope.search_ranked(query)
  end
end
end
