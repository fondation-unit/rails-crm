class Admin::NotesController < Admin::AdminController
  include MemberHelper

  def index
  end

  def new
    @note = Note.new
    @member_id = params[:member_id]
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to admin_member_path(note_params[:member_id]),
                  notice:
                    I18n.t(
                      "notes.created",
                      name: MemberHelper.full_name(@note.member)
                    )
    else
      flash[:alert] = @note.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.includes("member").find(params[:id])

    if @note.update(note_params)
      redirect_to admin_member_path(@note.member),
                  notice:
                    I18n.t(
                      "notes.updated",
                      name: MemberHelper.full_name(@note.member)
                    )
    else
      flash[:alert] = @note.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note = Note.includes("member").find(params[:id])
    puts @note.member
    if @note.destroy
      redirect_to admin_member_path(@note.member),
                  alert:
                    I18n.t(
                      "notes.deleted",
                      name: MemberHelper.full_name(@note.member)
                    )
    else
      redirect_to admin_member_path(@note.member),
                  alert: I18n.t("notes.error_update")
    end
  end

  def note_params
    params.expect(note: %i[content user_id member_id contact_type public])
  end
end
