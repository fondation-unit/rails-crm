class Admin::MemberTypesController < Admin::AdminController
  def index
    member_types = MemberType.ordered.order(sort_column => sort_direction)
    @pagy, @records = pagy(member_types)
  end

  def new
    @member_type = MemberType.new
  end

  def edit
    @member_type = MemberType.find(params[:id])
  end

  def create
    @member_type = MemberType.new(member_type_params)

    if @member_type.save
      redirect_to admin_member_types_path, notice: "Type de membre créé"
    else
      flash[:alert] = @member_type.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @member_type = MemberType.find(params[:id])

    if @member_type.update(member_type_params)
      redirect_to admin_member_types_path,
                  notice: "Type de membre \"#{@member_type.name}\" mis à jour"
    else
      flash[:alert] = @member_type.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member_type = MemberType.find(params[:id])
    nom = @member_type.name

    if @member_type.destroy
      redirect_to admin_member_types_path,
                  notice: "Type de membre \"#{nom}\" supprimé"
    else
      redirect_to admin_member_types_path,
                  alert: "Erreur lors de la suppression du type de membre"
    end
  end

  private

  def sort_column
    %w[id name].include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def member_type_params
    params.expect(member_type: [:name])
  end
end
