class Admin::MembersController < Admin::AdminController
  include MemberHelper
  include Searchable
  include Filterable

  before_action :set_organizations, only: %i[new create edit update]
  before_action :set_member_types, only: %i[new create edit update]


  def index
    p "*" * 90
    p params
    p "*" * 90
    # Requête initiale
    members = Member
                      .all
                      .includes(:organizations, :member_types, :notes)
                      .order(sort_column => sort_direction)
    # Application des filtres (s'il y en a en session)
    # members = apply_filters(members)
    # Complément de Requête (!= Elise Lucet)
    members = members.order(sort_column => sort_direction)

    respond_to do |format|
      format.html
      format.turbo_stream
    end

    @organizations = Organization.all.order(:name)

    @pagy, @records = pagy(members)
  end

  def show
    @member = Member.find(params[:id])
    notes = @member.notes
    @pagy, @notes = pagy(notes)
  end

  def new
    @member = Member.new
    @member_types = MemberType.ordered
  end

  def edit
    @member = Member.find(params[:id])
    @member_types = MemberType.ordered

    notes = @member.notes
    @pagy, @notes = pagy(notes)
  end

  def create
    @member = Member.new(member_params)

    if @member.save
      redirect_to admin_members_path,
                  notice:
                    I18n.t(
                      "members.created",
                      name: MemberHelper.full_name(@member)
                    )
    else
      flash[:alert] = @member.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @member = Member.find(params[:id])

    if @member.update(member_params)
      redirect_to admin_members_path,
                  notice:
                    I18n.t(
                      "members.updated",
                      name: MemberHelper.full_name(@member)
                    )
    else
      flash[:alert] = @member.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member = Member.find(params[:id])

    if @member.destroy
      redirect_to admin_members_path,
                  alert:
                    I18n.t(
                      "members.deleted",
                      name: MemberHelper.full_name(@member)
                    )
    else
      redirect_to admin_members_path, alert: I18n.t("members.error_update")
    end
  end

  def search
    records = search_records(Member)
    records = apply_filters(records)

    @pagy, @records = pagy(records)

    respond_to do |format|
      format.html { render "admin/members/list" }
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "search_results",
            partial: "admin/members/list",
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

  def filter
    # Utilisation de la méthode du concern Filterable
    members = apply_filters(Member.all)
    p "*" * 90
    p params
    p "*" * 90
    # Application de paramètres supplémentaires à la requête
    members = Member
               .all
               .includes(:organizations, :member_types, :notes)
                .references(:organizations)
               .where('organizations.name = ?', params[:organization])
               .order(sort_column => sort_direction) if params[:organization].present?

    @pagy, @records = pagy(members)

    # Remplacement des données dans la vue
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            "search_results",
            partial: "admin/members/list",
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

  def search_filters
    p "*" * 90
    p params
    p "*" * 90
    member = Member
               .all
               .includes(:organizations, :member_types, :notes)
               .where('organization.name = ?', "%#{params[:organization]}%" )
               .order(sort_column => sort_direction)
    @pagy, @records = pagy(member)
    render "index"
  end

  private

  def set_organizations
    @organizations = Organization.ordered
  end
  def set_member_types
    @member_types = MemberType.ordered
  end

  def sort_column
    if %w[id first_name last_name email_address].include?(params[:sort])
      params[:sort]
    else
      "id"
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def member_params
    params.expect(
      member: [
        :first_name,
        :last_name,
        :email_address,
        :position,
        :phone_number,
        :copil,
        :comex,
        :notes,
        :decisionnaire,
        :principal,
        :linkedin,
        :linkedin_connected,
        member_type_ids: [],
        organization_ids: []
      ]
    )
  end
end
