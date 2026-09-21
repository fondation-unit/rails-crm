class ReferentMailer < ApplicationMailer
  def investments_email
    @member = params[:member]
    recipients = generateRecipients(@member)
    mail(to: recipients, subject: "Nouveau membre sur le CRM PLAPIMA")
  end

  def generateRecipients(member)
    recipients = []

    if member.investments.any?
      member.investments.each do |investment|
        recipients.concat(
          [
            investment.referent1,
            investment.referent2,
            investment.copy
          ].compact_blank
        )
      end

      recipients.uniq!
    else
      recipients[] = ENV.fetch("REFERENT_EMAIL")
    end

    recipients.join(";")
  end
end
