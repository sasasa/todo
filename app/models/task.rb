class Task < ApplicationRecord
  validates :content, presence: true, length: {in: 5..100, allow_blank: true}, uniqueness: { scope: :user_id }

  belongs_to :user

  after_create :send_contact_email

  def late?
    due_on.in_time_zone < Date.current.in_time_zone
  end

  def user_name
    user.name
  end

  def send_contact_email
    Admin.all.each do |admin|
      ContactToCreateTaskMailer.contact_email(self, admin).deliver_later
      # ContactToCreateTaskMailer.contact_email(self, admin).deliver_now
    end
    ContactToCreateTaskMailer.confirmation_email(self).deliver_later
  end
end
