module Crm
  class NotesController < ApplicationController
    include MemberHelper

    def index
      authorize Note
    end

    def new
      @note = Note.new
      authorize @note

      @notable = find_notable
    end

    def create
      notable = find_notable
      @note = Note.new(note_params)
      authorize @note

      @note.notable = notable

      if @note.save
        redirect_to crm.polymorphic_path([crm, notable]),
                    notice: I18n.t("notes.created")
      else
        redirect_to crm.polymorphic_path([crm, notable]),
                    notice: @note.errors.full_messages.join(", ")
      end
    end

    def edit
      @note = Note.find(params[:id])
      authorize @note
    end

    def update
      @note = Note.includes(:notable).find(params[:id])
      authorize @note

      notable = @note.notable

      if @note.update(note_params)
        redirect_to crm.polymorphic_path([crm, notable]),
                    notice: I18n.t("notes.updated")
      else
        redirect_to crm.polymorphic_path([crm, notable]),
                    notice: @note.errors.full_messages.join(", ")
      end
    end

    def destroy
      @note = Note.includes(:notable).find(params[:id])
      authorize @note

      notable = @note.notable

      if @note.destroy
        redirect_to crm.polymorphic_path([crm, notable]),
                    alert: I18n.t("notes.deleted")
      else
        redirect_to crm.polymorphic_path([crm, notable]),
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
end
