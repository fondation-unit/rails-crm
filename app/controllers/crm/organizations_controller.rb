module Crm
  class OrganizationsController < ApplicationController
    include Filterable
    include Searchable

    def index
      organizations = policy_scope(Organization.includes(:notes))
      records = search_and_filter(organizations)
      organizations = records.order(sort_column => sort_direction)
      @pagy, @records = pagy(organizations)
    end

    def show
      @organization = Organization.includes(:members, :notes).find(params[:id])
      authorize @organization

      @pagy, @records = pagy(@organization.members)

      notes = @organization.notes
      @pagy2, @notes = pagy(notes)
    end

    def new
      @organization = Organization.new
      authorize @organization
    end

    def edit
      @organization = Organization.find(params[:id])
      authorize @organization

      notes = @organization.notes
      @pagy, @notes = pagy(notes)
    end

    def create
      @organization = Organization.new(organization_params)
      authorize @organization

      if @organization.save
        redirect_to crm.organizations_path, notice: "Institution créée"
      else
        redirect_to crm.organizations_path,
                    alert: @investment.errors.full_messages.join(", ")
      end
    end

    def update
      @organization = Organization.find(params[:id])
      authorize @organization

      if @organization.update(organization_params)
        redirect_to crm.organizations_path,
                    notice: "Institution \"#{@organization.name}\" mise à jour"
      else
        @organization.reload # Reload the object to get the existing attachment

        redirect_to crm.organizations_path,
                    alert: @investment.errors.full_messages.join(", ")
      end
    end

    def destroy
      @organization = Organization.find(params[:id])
      authorize @organization

      nom = @organization.name

      if @organization.destroy
        redirect_to crm.organizations_path,
                    notice: "Institution \"#{nom}\" supprimée"
      else
        redirect_to crm.organizations_path,
                    alert: "Erreur lors de la suppression de l'institution"
      end
    end

    def search
      authorize Organization, :search?
      records = policy_scope(search_and_filter)
      @pagy, @records = pagy(records)

      search_and_filter_render(@pagy, @records)
    end

    def filter
      records = search_and_filter
      @pagy, @records = pagy(records)

      search_and_filter_render(@pagy, @records)
    end

    def import
      authorize Organization
      uploaded_file = params[:csv_file]

      if uploaded_file.present?
        OrganizationImporter.new(uploaded_file, user: current_user).call

        redirect_to crm.organizations_path,
                    notice: I18n.t("members.organizations.imported")
      end
    end

    private

    def search_and_filter(scope = Organization)
      records = search_records(scope)
      filters = get_filters(records)

      filters&.each do |key, values|
        # Rejecter les paramètres qui ne correspondent pas à des attributs du modèle.
        # Nécessaire pour ne pas crasher à cause des paramètres en session issus d'autres contrôleurs.
        next unless records.column_names.include?(key.to_s)

        records = records.where(key => values)
      end

      records.includes(:notes).order(sort_column => sort_direction)
    end

    def search_and_filter_render(pagy, records)
      list_partial = "#{controller_path}/list"

      respond_to do |format|
        format.html do
          render partial: list_partial, locals: { records:, pagy: }
        end
        format.turbo_stream do
          render turbo_stream: [
                  turbo_stream.update(
                    "search_results",
                    partial: list_partial,
                    locals: {
                      records: records,
                      pagy: pagy
                    }
                  ),
                  turbo_stream.update(
                    "search_pagination",
                    partial: "shared/ui/pagy",
                    locals: {
                      pagy: pagy
                    }
                  )
                ]
        end
      end
    end

    def sort_column
      if %w[id name city status user_id].include?(params[:sort])
        params[:sort]
      else
        "created_at"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def organization_params
      params.expect(
        organization: %i[
          name
          address
          zip_code
          city
          lat
          lng
          logo
          linkedin
          linkedin_connected
          status
          type_orga
          remove_logo
          user_id
          notes
        ]
      )
    end
  end
end
