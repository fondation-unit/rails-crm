class Admin::MembersController < Admin::AdminController
  def index
    @members = Member.all
    @pagy, @records = pagy(@members)
  end

  def new
    @member = Member.new
    @member_types = MemberType.all.order("name" => "asc")
    @current_member_types = []
  end

  def create
    if @member = Member.create!(member_params)
      @member_types = params[:member_types]
      @member_types.each do |mtype|
        @member_type = MemberType.find(mtype)
        @member.member_types << @member_type
      end

      redirect_to admin_members_path, notice: "Membre #{@member.name} créé"
    else
      render :new
    end
  end

  def edit
    @member = Member.find(params[:id])
    @member_types = MemberType.all.order("name" => "asc")
    @current_member_types = @member.member_types
    #raise @current_member_types.inspect
  end

  def update
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
    params.expect(member: %i[name address zip_code city logo member_types])
  end
end
