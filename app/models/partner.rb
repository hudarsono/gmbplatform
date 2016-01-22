class Partner < ActiveRecord::Base
  attr_encrypted :plain_oauth2_token, :key => Rails.application.secrets.secret_key_base, :attribute => "oauth2_token"


  def update_token token 
    return if token.blank?

    self.oauth2_token_mark = eval(token)[:access_token][-5,5]
    self.plain_oauth2_token = token
    self.save
  end
end
