class Admin::MemberTypesController < Admin::AdminController
  def index
    @membersTypes = MemberType.all.order(sort_column => sort_direction)
    @pagy, @records = pagy(@membersTypes)
  end
  def new
    @memberType = MemberType.new
  end

  def create
    if @memberType = MemberType.create(post_params)
      redirect_to admin_member_types_path, notice: "Type de membre créé"
    else
      render :new
    end
  end

  def update
  end

  def destroy
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
