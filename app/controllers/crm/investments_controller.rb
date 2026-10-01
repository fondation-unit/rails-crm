module Crm
  class InvestmentsController < ApplicationController
    include Searchable
    include Filterable

    def index
      investments = Investment.all.order(sort_column => sort_direction)
      @pagy, @records = pagy(investments)
    end

    def new
      @investment = Investment.new
      authorize @investment
    end

    def create
      @investment = Investment.new(investment_params)
      authorize @investment

      if @investment.save
        redirect_to crm.investments_path,
                    notice: I18n.t("investments.created", name: @investment.name)
      else
        redirect_to crm.investments_path,
                    alert: @investment.errors.full_messages.join(", ")
      end
    end

    def edit
      @investment = Investment.find(params[:id])
      authorize @investment
    end

    def update
      @investment = Investment.find(params[:id])
      authorize @investment

      if @investment.update(investment_params)
        redirect_to crm.investments_path,
                    notice: I18n.t("investments.updated", name: @investment.name)
      else
        redirect_to crm.investments_path,
                    alert: @investment.errors.full_messages.join(", ")
      end
    end

    def destroy
      @investment = Investment.find(params[:id])
      authorize @investment

      if @investment.destroy
        redirect_to crm.investments_path,
                    notice: I18n.t("investments.updated", name: @investment.name)
      else
        redirect_to crm.investments_path,
                    alert: @investment.errors.full_messages.join(", ")
      end
    end

    private

    def sort_column
      if %w[id name referent1 referent2 copy].include?(params[:sort])
        params[:sort]
      else
        "id"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def investment_params
      params.expect(investment: %i[name referent1 referent2 copy])
    end
  end
end
