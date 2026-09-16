class Admin::MemberTypesController < Admin::AdminController
  def index
    member_types = MemberType.all.order(sort_column => sort_direction)
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
      redirect_to admin_member_types_path, notice: I18n.t(
        "members.member_type.created")
    else
      redirect_to admin_member_types_path,
                  alert: @member_type.errors.full_messages.join(", ")
    end
  end

  def update
    @member_type = MemberType.find(params[:id])

    if @member_type.update(member_type_params)
      redirect_to admin_member_types_path,
                  notice:
                    I18n.t(
                      "members.member_type.updated",
                      name: @member_type.name
                    )
    else
      redirect_to admin_member_types_path,
                  alert: @member_type.errors.full_messages.join(", ")
    end
  end

  def destroy
    @member_type = MemberType.find(params[:id])
    nom = @member_type.name

    if @member_type.destroy
      redirect_to admin_member_types_path,
                  notice: I18n.t("members.member_type.deleted", name: nom)
    else
      redirect_to admin_member_types_path,
                  alert: I18n.t("members.member_type.error_update")
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
