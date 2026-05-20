module Filterable
  extend ActiveSupport::Concern

  # Rendre la méthode current_filters accessible dans la vue (filter_bar)
  included { helper_method :current_filters }

  def current_filters
    session[:filters].to_h.symbolize_keys
  end

  def apply_filters(scope)
    filters = extract_filters
    
    if filters.any?
      filters.each_pair do |key, value|

        scope = scope.where("#{key} IN (#{value.join(',')})") if key.present?
        
      end
    end
    # À améliorer ou compléter en fonction de la nature des filtres vidés...
    # scope = scope.where(status: filters[:status]) if filters[:status].present?

    # La fonction retourne la requête agrémentée par les filtres
    scope
  end

  private

  def extract_filters

    
    # Formulaire soumis avec ou sans filtres cochés
    if params.key?(:filters)
      filters =
        params
          .fetch(:filters, {})
          .permit!
          .to_h
          .symbolize_keys
          .reject { |_, v| v.blank? }

      end
      # Si aucun filtre sélectionné, suppression dans la session
      if filters.nil?
        session.delete(:filters)
        return {}
      end

      session[:filters] = filters
      return filters

    # Réutilisation de la session pour la pagination
    current_filters
  end
end
