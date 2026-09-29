module Crm
  class DisciplinesController < ApplicationController
    def index
      disciplines = Discipline.all.order(sort_column => sort_direction)
      @pagy, @records = pagy(disciplines)
    end

    def new
      @discipline = Discipline.new
    end

    def edit
      @discipline = Discipline.find(params[:id])
    end

    def create
      @discipline = Discipline.new(discipline_params)

      if @discipline.save
        redirect_to admin_disciplines_path,
                    notice: I18n.t("members.discipline.created")
      else
        redirect_to admin_disciplines_path,
                    alert: @discipline.errors.full_messages.join(", ")
      end
    end

    def update
      @discipline = Discipline.find(params[:id])

      if @discipline.update(discipline_params)
        redirect_to admin_disciplines_path,
                    notice:
                      I18n.t("members.discipline.updated", name: @discipline.name)
      else
        redirect_to admin_disciplines_path,
                    alert: @discipline.errors.full_messages.join(", ")
      end
    end

    def destroy
      @discipline = Discipline.find(params[:id])

      if @discipline.destroy
        redirect_to admin_disciplines_path,
                    notice:
                      I18n.t("members.discipline.deleted", name: @discipline.name)
      else
        redirect_to admin_disciplines_path,
                    alert: I18n.t("members.discipline.error_update")
      end
    end

    private

    def sort_column
      %w[id name].include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def discipline_params
      params.expect(discipline: [:name])
    end
  end
end
