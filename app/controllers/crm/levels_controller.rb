module Crm
  class LevelsController < ApplicationController
    def index
      levels = Level.all.order(sort_column => sort_direction)
      @pagy, @records = pagy(levels)
    end

    def new
      @level = Level.new
    end

    def edit
      @level = Level.find(params[:id])
    end

    def create
      @level = Level.new(level_params)

      if @level.save
        redirect_to levels_path, notice: I18n.t("members.level.created")
      else
        redirect_to levels_path,
                    alert: @level.errors.full_messages.join(", ")
      end
    end

    def update
      @level = Level.find(params[:id])

      if @level.update(level_params)
        redirect_to levels_path,
                    notice: I18n.t("members.level.updated", name: @level.name)
      else
        redirect_to levels_path,
                    alert: @level.errors.full_messages.join(", ")
      end
    end

    def destroy
      @level = Level.find(params[:id])
      nom = @level.name

      if @level.destroy
        redirect_to levels_path,
                    notice: I18n.t("members.level.deleted", name: nom)
      else
        redirect_to levels_path, alert: I18n.t("members.level.error_update")
      end
    end

    private

    def sort_column
      %w[id name].include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def level_params
      params.expect(level: [:name])
    end
  end
end
