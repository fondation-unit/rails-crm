module Filterable
  extend ActiveSupport::Concern

  def apply_filters(scope:, template:)
    filters = params.fetch(:filters, {}).permit!

    scope = scope.where(status: filters[:status]) if filters[:status].present?

    @pagy, @records = pagy(scope)

    respond_to do |format|
      format.html { render template }
      format.turbo_stream do
        render turbo_stream: [
                 turbo_stream.update(
                   "search_results",
                   partial: template,
                   locals: {
                     records: @records,
                     pagy: @pagy
                   }
                 ),
                 turbo_stream.update(
                   "search_pagination",
                   partial: "shared/ui/pagy",
                   locals: {
                     pagy: @pagy
                   }
                 )
               ]
      end
    end
  end
end
