module Crm
  class ReferentMailDeliveryJob < ActionMailer::MailDeliveryJob
    discard_on ActiveJob::DeserializationError
  end
end
