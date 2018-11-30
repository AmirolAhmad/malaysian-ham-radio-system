class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable, authentication_keys: [:login]

  attr_writer :login
  validates :client_number, presence: :true, uniqueness: { case_sensitive: false }
  validate :validate_client_number

  def login
    @login || self.client_number || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(client_number) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:client_number].nil?
        where(conditions).first
      else
        where(client_number: conditions[:client_number]).first
      end
    end
  end

  def validate_client_number
    if User.where(email: client_number).exists?
      errors.add(:client_number, :invalid)
    end
  end
end
