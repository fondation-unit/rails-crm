class Admin::NotesController < Admin::AdminController
  include MemberHelper
  include Pundit::Authorization

  def index
  end

  def new
    @note = Note.new
    @notable = find_notable
  end

  def create
    notable = find_notable
    @note = Note.new(note_params)
    @note.notable = notable

    if @note.save
      redirect_to polymorphic_path([:admin, @note.notable]),
                  notice: I18n.t("notes.created")
    else
      flash[:alert] = @note.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.includes(:notable).find(params[:id])
    notable = @note.notable

    if @note.update(note_params)
      redirect_to polymorphic_path([:admin, notable]),
                  notice: I18n.t("notes.updated")
    else
      flash[:alert] = @note.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note = Note.includes(:notable).find(params[:id])
    notable = @note.notable

    if @note.destroy
      redirect_to polymorphic_path([:admin, notable]),
                  alert: I18n.t("notes.deleted")
    else
      redirect_to polymorphic_path([:admin, notable]),
                  alert: I18n.t("notes.error_update")
    end
  end

  private

  def find_notable
    if params[:member_id]
      Member.find(params[:member_id])
    elsif params[:organization_id]
      Organization.find(params[:organization_id])
    end
  end

  def note_params
    params.expect(note: %i[content user_id contact_type public])
  end
end
