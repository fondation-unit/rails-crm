class Admin::NotesController < Admin::AdminController
  def index
  end

  def new
    @note = Note.new
    @member_id = params[:member_id]
  end

  def create
    @note = Note.new(note_params)
    @member = Member.find(note_params[:member_id])
    if @note.save
      redirect_to admin_members_path,
                  notice:
                    "Note pour le membre #{@member.first_name} #{@member.last_name} créé"
    else
      flash[:alert] = @note.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    @member = Member.find(@note.member_id)

    if @note.update(note_params)
      redirect_to admin_members_path,
                  notice:
                    "note pour le membre \"#{@member.first_name} #{@member.last_name}\" mis à jour"
    else
      flash[:alert] = @note.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def note_params
    params.expect(note: %i[content user_id member_id contact_type public])
  end
end
