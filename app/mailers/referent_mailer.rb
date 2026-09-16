class ReferentMailer < ApplicationMailer
    def investments_email
        member = params[:member]
        recipients = generateRecipients(member)
        message = generateMessage(member)
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

    def generateMessage(member)
        message = "#{member.first_name} #{member.last_name} a choisi de s'investir dans le projet PLAPIMA.
            Il souhaite : \n"
        member.investments.each do |i|
            message += " - " + i.name + "\n"
        end

        if member.investments.length > 1
            message += "ATTENTION : ce membre a choisi de s'investir dans plusieurs thématiques, il convient donc de voir avec les autres référents qui doit l'appeler"
        end
    end
end
