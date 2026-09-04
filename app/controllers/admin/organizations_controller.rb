class Admin::OrganizationsController < Admin::AdminController
  include Filterable
  include Searchable

  def index
    # Requête initiale
    organizations = Organization.includes(:notes)
    # Application des filtres s'il y en a en session
    records = search_and_filter(organizations)
    # Complément de requête
    organizations = records.order(sort_column => sort_direction)
    @pagy, @records = pagy(organizations)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @organization = Organization.includes(:members, :notes).find(params[:id])
    @pagy, @records = pagy(@organization.members)
    notes = @organization.notes
    @pagy2, @notes = pagy(notes)
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = Organization.find(params[:id])
    notes = @organization.notes
    @pagy, @notes = pagy(notes)
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to admin_organizations_path, notice: "Institution créée"
    else
      redirect_to admin_organizations_path,
                  alert: @investment.errors.full_messages.join(", ")
    end
  end

  def update
    @organization = Organization.find(params[:id])

    if @organization.update(organization_params)
      redirect_to admin_organizations_path,
                  notice: "Institution \"#{@organization.name}\" mise à jour"
    else
      @organization.reload # Reload the object to get the existing attachment

      redirect_to admin_organizations_path,
                  alert: @investment.errors.full_messages.join(", ")
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    nom = @organization.name

    if @organization.destroy
      redirect_to admin_organizations_path,
                  notice: "Institution \"#{nom}\" supprimée"
    else
      redirect_to admin_organizations_path,
                  alert: "Erreur lors de la suppression de l'institution"
    end
  end

  def search
    records = search_and_filter
    @pagy, @records = pagy(records)

    search_and_filter_render(@pagy, @records)
  end

  def filter
    records = search_and_filter
    @pagy, @records = pagy(records)

    search_and_filter_render(@pagy, @records)
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

    records = records.includes(:notes).order(sort_column => sort_direction)
    records
  end

  def search_and_filter_render(pagy, records)
    respond_to do |format|
      format.html { render "admin/organizations/list" }
      format.turbo_stream do
        render turbo_stream: [
                 turbo_stream.update(
                   "search_results",
                   partial: "admin/organizations/list",
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
