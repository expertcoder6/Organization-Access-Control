class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :organization_users
  has_many :organizations, through: :organization_users

  before_validation :calculate_age

  def calculate_age
    return unless date_of_birth.present?
    self.age = ((Time.zone.today - date_of_birth).to_i / 365.25).floor
  end

  def age_group
    return :child if age < 13
    return :teen if age < 18
    :adult
  end

  validate :parent_email_required_for_minors

  def minor?
    age.present? && age < 18
  end

  def parent_email_required_for_minors
    return unless minor?

    if parent_email.blank?
      errors.add(:parent_email, "is required for users under 18")
    elsif User.find_by(email: parent_email).nil?
      errors.add(:parent_email, "must belong to an existing user (your parent)")
    elsif parent_email == email
      errors.add(:parent_email, "cannot be the same as your own email")
    end
  end
end
