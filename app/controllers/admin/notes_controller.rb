class Admin::NotesController < Admin::AdminController
  def index
  end

  def edit
    @note = Note.find(params[:id])
  end

  def destroy
  end
end
