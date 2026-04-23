class Admin::OrganizationsController < Admin::AdminController
  include Filterable
  include Searchable

  def index
    organizations =
      Organization.all.includes(:notes).order(sort_column => sort_direction)
    @pagy, @records = pagy(organizations)
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
      flash[:alert] = @organization.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @organization = Organization.find(params[:id])

    if @organization.update(organization_params)
      redirect_to admin_organizations_path,
                  notice: "Institution \"#{@organization.name}\" mise à jour"
    else
      @organization.reload # Reload the object to get the existing attachment

      flash[:alert] = @organization.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
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
    search_records(model: Organization, template: "admin/organizations/list")
  end

  def filter
    @organizations =
      apply_filters(
        scope: Organization.all,
        template: "admin/organizations/list"
      )
  end

  private

  def sort_column
    if %w[id name city status].include?(params[:sort])
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
        notes
      ]
    )
  end
end
