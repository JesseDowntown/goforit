class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :goals
  has_many :partners, through: :goals

  # validates :first_name, :last_name, :email_address, :description, presence: true

  def full_name
  	"#{first_name} #{last_name}"
  end


end
