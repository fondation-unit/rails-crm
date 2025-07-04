class Admin::MembersController < Admin::AdminController
  def index
    @members = Member.all
    @pagy, @records = pagy(@members)
  end

  def new
    @member = Member.new
    @member_types = MemberType.ordered
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to admin_members_path, notice: "Membre #{@member.name} créé"
    else
      render :new
    end
  end

  def edit
    @member = Member.find(params[:id])
    @member_types = MemberType.ordered
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to admin_members_path,
                  notice: "Membre \"#{@member.name}\" mis à jour"
    end
  end

  def destroy
    @member = Member.find(params[:id])
    nom = @member.name
    if @member.destroy!
      redirect_to admin_members_path, notice: "Membre \"#{nom}\" supprimé"
    end
  end

  private

  def member_params
    params.expect(
      member: [:name, :address, :zip_code, :city, :logo, member_type_ids: []]
    )
  end
end
