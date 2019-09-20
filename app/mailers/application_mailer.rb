class ApplicationMailer < ActionMailer::Base
  # default from: 'from@example.com'
  default from: "support@example.com"
  layout 'mailer'
end
