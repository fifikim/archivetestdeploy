class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar, dependent: :destroy
  has_many :uploads, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  enum role: [:user, :admin]
  after_initialize :set_default_role, if: :new_record?

  private
  def set_default_role
    self.role ||= :user
  end
end
