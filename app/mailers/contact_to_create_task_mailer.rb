class ContactToCreateTaskMailer < ApplicationMailer
  default from: "support@example.com"
  
  def contact_email(task, admin)
    @task = task
    @admin = admin
    mail(to: @admin.email, subject: "新しいタスクが作成されました。")
  end

  def confirmation_email(task)
    @task = task
    mail(to: @task.user.email, subject: "新しいタスクが作成されました。")
  end
end
