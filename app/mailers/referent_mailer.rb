class ReferentMailer < ApplicationMailer
    def investments_email
        @member = params[:member]
        recipients = generateRecipients(@member)
        mail(to: recipients, subject: "Nouveau membre sur le CRM PLAPIMA")
    end

    def generateRecipients(member)
        recipients = []
        if member.investments.length
            member.investments.each do |i|
                recipients.push(i.referent1) if !recipients.include?(i.referent1)
                recipients.push(i.referent2) if !recipients.include?(i.referent2)
                recipients.push(i.copy) if !recipients.include?(i.copy)
            end
        else
            recipients[] = "postmaster@lapatweb.fr"
        end
        recipients.join(';')
    end
end
