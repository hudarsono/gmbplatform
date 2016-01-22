class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable



  def admin?
    return true if self.email = "hudarsono@gopherindonesia.com"
    false
  end
end
