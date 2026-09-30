module Crm
  class MembersController < ApplicationController
    include MemberHelper
    include Searchable
    include Filterable

    before_action :set_organizations, only: %i[new create edit update]
    before_action :set_member_types, only: %i[new create edit update]
    before_action :set_investments, only: %i[new create edit update]
    before_action :set_levels, only: %i[new create edit update]
    before_action :set_disciplines, only: %i[new create edit update]

    def index
      members =
        Member.includes(
          :organizations,
          :member_types,
          :notes,
          :levels,
          :disciplines,
          :investments
        ).order(sort_column => sort_direction)

      members = policy_scope(members)
      records = search_and_filter(members)
      members = records.order(sort_column => sort_direction)

      respond_to do |format|
        format.html
        format.turbo_stream
      end

      @organizations = Organization.order(:name)
      @investments = Investment.order(:name)

      @pagy, @records = pagy(members)
    end

    def show
      @member = Member.find(params[:id])
      authorize @member

      notes = @member.notes
      @pagy, @notes = pagy(notes)
    end

    def new
      @member = Member.new
      authorize @member

      @member_types = MemberType.ordered
      @investments = Investment.ordered
      @levels = Level.ordered
      @disciplines = Discipline.ordered
    end

    def edit
      @member = Member.find(params[:id])
      authorize @member

      @member_types = MemberType.ordered
      @investments = Investment.ordered
      @levels = Level.ordered
      @disciplines = Discipline.ordered

      notes = @member.notes
      @pagy, @notes = pagy(notes)
    end

    def create
      @member = Member.new(member_params)
      authorize @member

      if @member.save
        ReferentMailer.with(member: @member).investments_email.deliver_later
        redirect_to members_path,
                    notice:
                      I18n.t(
                        "members.created",
                        name: MemberHelper.full_name(@member)
                      )
      else
        redirect_to members_path,
                    alert: @member.errors.full_messages.join(", ")
      end
    end

    def update
      @member = Member.find(params[:id])
      authorize @member

      if @member.update(member_params)
        redirect_to members_path,
                    notice:
                      I18n.t(
                        "members.updated",
                        name: MemberHelper.full_name(@member)
                      )
      else
        redirect_to members_path,
                    alert: @member.errors.full_messages.join(", ")
      end
    end

    def destroy
      @member = Member.find(params[:id])
      authorize @member

      if @member.destroy
        redirect_to members_path,
                    alert:
                      I18n.t(
                        "members.deleted",
                        name: MemberHelper.full_name(@member)
                      )
      else
        redirect_to members_path, alert: I18n.t("members.error_update")
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
      authorize Member
      uploaded_file = params[:csv_file]

      if uploaded_file.present?
        MemberImporter.new(uploaded_file, user: current_user).call

        redirect_to members_path, notice: I18n.t("members.imported")
      end
    end

    private

    def search_and_filter(scope = Member)
      records = search_records(scope)
      filters = get_filters(records)

      filters&.each do |key, values|
        key = key.to_s

        records =
          case key
          when "organization_ids"
            records.joins(:organizations).where(organizations: { id: values })
          when "member_type_ids"
            records
              .joins(:member_types)
              .where(member_types: { id: values })
              .where(organizations: { id: values })
          when "investment_ids"
            records.joins(:investments).where(investments: { id: values })
          else
            # Rejecter les paramètres qui ne correspondent pas à des attributs du modèle.
            # Nécessaire pour ne pas crasher à cause des paramètres en session issus d'autres contrôleurs.
            next unless records.column_names.include?(key.to_s)

            records.where(key => values)
          end
      end

      records.order(sort_column => sort_direction)
    end

    def search_and_filter_render(pagy, records)
      respond_to do |format|
        format.html { render "members/list" }
        format.turbo_stream do
          render turbo_stream: [
                  turbo_stream.update(
                    "search_results",
                    partial: "members/list",
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

    def set_levels
      @levels = Level.ordered
    end

    def set_disciplines
      @disciplines = Discipline.ordered
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
          :status,
          member_type_ids: [],
          investment_ids: [],
          organization_ids: [],
          level_ids: [],
          discipline_ids: []
        ]
      )
    end
  end
end
