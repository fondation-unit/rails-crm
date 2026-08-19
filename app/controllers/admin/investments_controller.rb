class Admin::InvestmentsController < Admin::AdminController
  include Searchable
  include Filterable
  include Pundit::Authorization

  def index
  investments = Investment.all.order(sort_column => sort_direction)
    @pagy, @records = pagy(investments)
  end

  def new
    @investment = Investment.new
  end

  def create
    @investment = Investment.new(investment_params)

    if @investment.save
      redirect_to admin_investments_path,
                  notice:
                    I18n.t(
                      "investment.created",
                      name: @investment.name
                    )
    else
      flash[:alert] = @investment.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @investment = Investment.find(params[:id])
  end

  def update
    @investment = Investment.find(params[:id])

    if @investment.update(investment_params)
      p '*' * 10
      p investment_params
      p '*' * 10
      redirect_to admin_investments_path,
                  notice:
                    I18n.t(
                      "investment.updated",
                      name: @investment.name
                    )
    else
      flash[:alert] = @investment.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @investment = Investment.includes(:notable).find(params[:id])
    notable = @investment.notable

    if @investment.destroy
      redirect_to polymorphic_path([:admin, notable]),
                  alert: I18n.t("Investments.deleted")
    else
      redirect_to polymorphic_path([:admin, notable]),
                  alert: I18n.t("Investments.error_update")
    end
  end

  private

  def sort_column
    if %w[id name email_address].include?(params[:sort])
      params[:sort]
    else
      "id"
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def investment_params
    params.expect(investment: %i[name email_address])
  end
end
