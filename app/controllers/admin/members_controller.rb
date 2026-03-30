class Admin::MembersController < Admin::AdminController
  include MemberHelper
  include Searchable

  before_action :set_organizations, only: %i[new create edit update]
  before_action :set_member_types, only: %i[new create edit update]


  def index
    members =
      Member
        .all
        .includes(:organizations, :member_types, :notes)
        .order(sort_column => sort_direction)

    @pagy, @records = pagy(members)
  end

  def show
    @member = Member.find(params[:id])
    notes = Note.for_member(current_user, @member.id)
    @pagy, @notes = pagy(notes)
  end

  def new
    @member = Member.new
    @member_types = MemberType.ordered
  end

  def edit
    @member = Member.find(params[:id])
    @member_types = MemberType.ordered

    notes = Note.for_member(current_user, @member.id)
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
    search_records(model: Member, template: "members/list")
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
