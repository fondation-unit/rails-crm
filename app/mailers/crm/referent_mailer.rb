module Crm
  class ReferentMailer < ApplicationMailer
    discard_on ActiveJob::DeserializationError

    def investments_email
      @member = params[:member]
      recipients = generate_recipients(@member)

      mail(to: recipients, subject: "Nouveau membre sur le CRM PLAPIMA")
    end

    def generate_recipients(member)
      recipients =
        if member.investments.any?
          member.investments.flat_map do |investment|
            [investment.referent1, investment.referent2, investment.copy]
          end
        else
          [ENV.fetch("REFERENT_EMAIL")]
        end

      recipients.compact_blank.uniq.join(";")
    end
  end
end
