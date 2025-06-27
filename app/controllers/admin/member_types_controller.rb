class Admin::MemberTypesController < Admin::AdminController
  def index
    @membersTypes = MemberType.order(sort_column => sort_direction)
  end
  def new
  end

  def create
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
end
