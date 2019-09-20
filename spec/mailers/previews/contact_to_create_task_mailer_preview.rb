# Preview all emails at http://localhost:3000/rails/mailers/contact_to_create_task_mailer
class ContactToCreateTaskMailerPreview < ActionMailer::Preview
  def contact_email
    user = User.new(email: "user@gmail.com", first_name: "佐藤", last_name: "まさし")
    task = Task.new(content: "筋トレをする", due_on: 1.week.after, user: user)
    admin = Admin.new(email: "admin@gmail.com")
    ContactToCreateTaskMailer.contact_email(task, admin)
  end

  def confirmation_email_with_name
    user = User.new(email: "user@gmail.com", first_name: "佐藤", last_name: "まさし")
    task = Task.new(content: "筋トレをする", due_on: 1.week.after, user: user)
    ContactToCreateTaskMailer.confirmation_email(task)
  end

  def confirmation_email_without_name
    user = User.new(email: "user@gmail.com")
    task = Task.new(content: "筋トレをする", due_on: 1.week.after, user: user)
    ContactToCreateTaskMailer.confirmation_email(task)
  end
end