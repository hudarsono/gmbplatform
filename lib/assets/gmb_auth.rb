require 'signet/oauth_2/client'

module GmbAuth
  GOOGLE_TOKEN_INFO_URL = 'https://www.googleapis.com/oauth2/v3/tokeninfo'

  def create_gmb_client(partner_id=nil)

    partner = Partner.find(partner_id)

  	client = Signet::OAuth2::Client.new(
      :authorization_uri => 'https://accounts.google.com/o/oauth2/v2/auth',
      :token_credential_uri =>  'https://www.googleapis.com/oauth2/v3/token',
      :client_id => ENV['GMB_OAUTH2_CLIENT_ID'],
      :client_secret => ENV['GMB_OAUTH2_CLIENT_SECRET'],
      :scope => 'https://www.googleapis.com/auth/plus.business.manage',
      :state => { partner_id: partner.id }.to_param
    )

    # add offline access 
    client.update!(
      :additional_parameters => {"access_type" => "offline", "prompt" => "consent"}
    )

    # check if token available
    if partner.oauth2_token.present?
      # assign token
      client.update_token!(eval(partner.plain_oauth2_token))

      # verify access token validity, if no longer valid, then refresh
      if !verify_access_token(client.access_token)
        new_token = client.refresh!

        # store new token 
        new_token[:refresh_token] = client.refresh_token
        partner.update_token(new_token.to_json)
      end

    end

    client

  end

  private 

  def verify_access_token access_token
    uri = URI.parse(GOOGLE_TOKEN_INFO_URL)
    uri.query = [uri.query, "access_token=#{access_token}"].compact.join('&')

    resp = Net::HTTP.get_response(uri)

    resp.is_a?(Net::HTTPOK)
  end
end