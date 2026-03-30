module Searchable
  extend ActiveSupport::Concern

  def search_records(model:, template:, policy: true)
    records = params[:q].present? ? model.search_ranked(params[:q]) : model.all
    authorize records if policy
    @pagy, @records = pagy(records)

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