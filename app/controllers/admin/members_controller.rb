class Admin::MembersController < Admin::AdminController
  include MemberHelper
  include Searchable
  include Filterable

  require 'csv'

  before_action :set_organizations, only: %i[new create edit update]
  before_action :set_member_types, only: %i[new create edit update]
  before_action :set_investments, only: %i[new create edit update]

  def index
    # Requête initiale
    members =
      Member.includes(:organizations, :member_types,  :notes).order(
        sort_column => sort_direction
      )
    # Application des filtres (s'il y en a en session)
    records = search_and_filter(members)
    # Complément de Requête (!= Elise Lucet)
    members = records.order(sort_column => sort_direction)

    respond_to do |format|
      format.html
      format.turbo_stream
    end

    @organizations = Organization.order(:name)

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
    @investments = Investment.ordered
  end

  def edit
    @member = Member.find(params[:id])
    @member_types = MemberType.ordered
    @investments = Investment.ordered

    notes = @member.notes
    @pagy, @notes= pagy(notes)
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
    scope = Member.includes(:notes)
    records = search_and_filter(scope)

    @pagy, @records = pagy(records)

    search_and_filter_render(@pagy, @records)
  end

  def filter
    scope = Member.includes(:notes)
    records = search_and_filter(scope)

    @pagy, @records = pagy(records)

    search_and_filter_render(@pagy, @records)
  end

  def import
    uploaded_file = params[:csv_file]
    if uploaded_file.present?
      csv_data = CSV.parse(uploaded_file.read, headers: true)
      csv_data.each do |row|
        exp = row[0].split(';');
        import_member(exp)
      end
    end
  end

  private

  def import_member(exp)
    #orga = OrganizationHelper.update_or_create(exp)
    member_update = self.update_or_create(exp)
    p '*' * 90
    p member_update
    p '*' * 90


    if !exp[21].to_s.empty?
      note_fields = {
        user_id: current_user,
        notable_type: 'Member',
        notable_id: member_update[:id]
      }
      Note.new(note_fields)
    end

  end

  def generate_member_fields(exp, orga=nil)

    member_fields = {
      first_name: MemberHelper.utf_decode(exp[1]),
      last_name: MemberHelper.utf_decode(exp[2]),
      email_address: exp[3],
      phone_number: nil,
      newsletter_ressources: exp[16] == 'Oui' ? true : false,
      invest: (exp[17] == 'Oui' || exp[18] == 'Oui'  || exp[19] == 'Oui'  || exp[20] == 'Oui') ? true : false,
    }  
    
    

   
      investment_ids = []
 
      investment_ids << 1 if exp[17] == "Oui"
      investment_ids << 2 if exp[18] == "Oui"
      investment_ids << 3 if exp[19] == "Oui"
      investment_ids << 4 if exp[20] == "Oui"
    
      member_fields[:investment_ids] = investment_ids
    
      member_fields
    
  end

  def update_or_create(exp)
    member = Member.find_by(email_address:exp[3])
    member_fields = self.generate_member_fields(exp)
    if member
      member.update!(member_fields)
    else
      member = Member.create!(member_fields)
    end
    member
  end

  def search_and_filter(scope = Member)
    records = search_records(scope)
    filters = get_filters(records)

    filters&.each do |key, values|
      key = key.to_s

      case key
      when "organization_ids"
        records =
          records.joins(:organizations).where(organizations: { id: values })
      when "member_type_ids"
        records =
          records.joins(:member_types).where(member_types: { id: values })
      else
        # Rejecter les paramètres qui ne correspondent pas à des attributs du modèle.
        # Nécessaire pour ne pas crasher à cause des paramètres en session issus d'autres contrôleurs.
        next unless records.column_names.include?(key.to_s)

        records = records.where(key => values)
      end
    end

    records = records.order(sort_column => sort_direction)
    records
  end

  def search_and_filter_render(pagy, records)
    respond_to do |format|
      format.html { render "admin/members/list" }
      format.turbo_stream do
        render turbo_stream: [
                 turbo_stream.update(
                   "search_results",
                   partial: "admin/members/list",
                   locals: {
                     records: records,
                     pagy: pagy
                   }
                 ),
                 turbo_stream.update(
                   "search_pagination",
                   partial: "shared/ui/pagy",
                   locals: {
                     pagy: pagy
                   }
                 )
               ]
      end
    end
  end

  def set_organizations
    @organizations = Organization.ordered
  end

  def set_member_types
    @member_types = MemberType.ordered
  end

  def set_investments
    @investments = Investment.ordered
  end

  def transform_array(ar, value)
    ar.to_h { |key| [key, value] }
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
        :newsletter_ressources,
        :invest,
        member_type_ids: [],
        investment_ids: [],
        organization_ids: []
      ]
    )
  end
end
