module Filterable
  extend ActiveSupport::Concern

  # Rendre la méthode current_filters accessible dans la vue (filter_bar)
  included { helper_method :current_filters }

  def current_filters
    session[:filters].to_h.symbolize_keys
  end

  def get_filters(scope = nil)
    raw_filters = params[:filters]

    # Si aucun filtre envoyé, on se base sur la session
    return current_filters if raw_filters.blank?

    filters =
      raw_filters
        .permit!
        .to_h
        .symbolize_keys
        .except(:__sent) # champ pour déterminer si tout a été décoché
        .reject { |_, v| v.blank? }

    # Si aucun filtre sélectionné, suppression dans la session
    if filters.empty?
      session.delete(:filters)
      return {}
    end

    session[:filters] = filters
    current_filters # réutilisation de la session pour la pagination
  end
end
