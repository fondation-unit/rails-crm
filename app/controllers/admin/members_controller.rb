class Admin::MembersController < Admin::AdminController
  def index
    members =
      Member.all.includes(:organizations).order(sort_column => sort_direction)

    @pagy, @records = pagy(members)
  end

  def new
    @member = Member.new
    @member_types = MemberType.ordered
    @organizations = Organization.ordered
  end

  def create
    @member = Member.new(member_params)

    if @member.save
      redirect_to admin_members_path,
                  notice:
                    "Membre #{@member.first_name} #{@member.last_name} créé"
    else
      flash[:alert] = @member.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @member = Member.find(params[:id])
    @organizations = Organization.ordered
    @member_types = MemberType.ordered
  end

  def update
    @member = Member.find(params[:id])

    if @member.update(member_params)
      redirect_to admin_members_path,
                  notice:
                    "Membre \"#{@member.first_name} #{@member.last_name}\" mis à jour"
    else
      flash[:alert] = @member.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member = Member.find(params[:id])
    nom = @member.last_name

    if @member.destroy
      redirect_to admin_members_path, alert: "Membre \"#{nom}\" supprimé"
    else
      redirect_to admin_members_path,
                  alert: "Erreur lors de la suppression du membre"
    end
  end

  private

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
        member_type_ids: [],
        organization_ids: []
      ]
    )
  end
end
