class Admin::MemberTypesController < Admin::AdminController
  def index
    member_types = MemberType.ordered
    @pagy, @records = pagy(member_types)
  end
  def new
    @member_type = MemberType.new
  end

  def create
    if @member_type = MemberType.create!(post_params)
      redirect_to admin_member_types_path, notice: "Type de membre créé"
    else
      render :new
    end
  end

  def edit
    @member_type = MemberType.find(params[:id])
  end

  def update
    @member_type = MemberType.find(params[:id])
    if @member_type.update!(post_params)
      redirect_to admin_member_types_path,
                  notice: "Type de membre \"#{@member_type.name}\" mis à jour"
    else
      render :edit
    end
  end

  def destroy
    @member_type = MemberType.find(params[:id])
    nom = @member_type.name
    if @member_type.destroy!
      redirect_to admin_member_types_path,
                  notice: "Type de membre \"#{nom}\" supprimé"
    end
  end

  private

  def sort_column
    %w[id name].include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def post_params
    params.expect(member_type: [:name])
  end
end
