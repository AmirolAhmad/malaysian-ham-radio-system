class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable, authentication_keys: [:login]

  attr_writer :login
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validate :validate_username

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  def validate_username
    if Admin.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end
end
