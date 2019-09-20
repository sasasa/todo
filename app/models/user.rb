class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
    :rememberable, :validatable, :trackable, :confirmable, :lockable, :timeoutable

  has_many :tasks

  has_one_attached :image

  before_save :ensure_authentication_token

  # geocodeメソッドが追加される 
  geocoded_by :last_sign_in_ip do |user, result|
    if !user.local? && geocode = result.first
      user.location = "#{geocode.city}, #{geocode.state}, #{geocode.country}"
      user.save
    end
  end

  # パスワード認証後に毎回呼ばれる
  def after_database_authentication
    GeocodeUserJob.perform_later self
    # 「キューイングシステムが空いたらジョブを実行する」とキューに登録する
    # MailDeliveryJob.perform_later mail
    # 明日正午に実行したいジョブをキューに登録する
    # MailDeliveryJob.set(wait_until: Date.tomorrow.noon).perform_later(mail) 
    # 一週間後に実行したいジョブをキューに登録する
    # MailDeliveryJob.set(wait: 1.week).perform_later(mail)
  end

  def local?
    [
      "localhost",
      "127.0.0.1",
      "0.0.0.0",
      "10.0.2.2"
    ].include? last_sign_in_ip
  end

  def name
    if first_name? && last_name?
      first_name + " " + last_name
    else
      ""
    end
  end

  def name?
    name.present?
  end

  def email_first_half
    email.sub(/@.*/, "")
  end

  private
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
