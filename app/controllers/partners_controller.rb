class PartnersController < ApplicationController
  include GmbAuth

  def index 
    respond_to do |format|
      format.html
      format.json {
        filters = {}
        render json: PartnersDatatable.new(view_context)
      }
    end
  end

  def new 
    @partner = Partner.new
  end

  def create 
    @partner = Partner.new(partner_params)

    respond_to do |format|
      if @partner.save
        format.html { redirect_to partners_path, notice: 'Partner was successfully created.' }
        format.json { render :show, status: :created, location: @partner }
      else
        format.html { render :new }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  def show 

  end

  def edit
    @partner = Partner.find(params[:id])
  end

  def update 
    @partner = Partner.find(params[:id])
    respond_to do |format|
      if @partner.update(partner_params)
        format.html { redirect_to partners_path, notice: 'Partner was successfully updated.' }
        format.json { render :show, status: :ok, location: @partner }
      else
        format.html { render :edit }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  def oauth2_prompt
    partner = Partner.find(params[:id])

    token = partner.oauth2_token
    if token.present? 
      redirect_to partners_path, :notice => "Token does already exist!"
    else
      client = create_gmb_client(partner.id)
      client.redirect_uri = oauth2_callback_partners_url

      redirect_to(client.authorization_uri.to_s)
    end
  end

  def oauth2_callback
    partner_id = CGI::parse(params[:state])["partner_id"].first

    client = create_gmb_client(partner_id)
    client.code = params[:code]
    client.redirect_uri = oauth2_callback_partners_url

    begin
      access_token = client.fetch_access_token!

      partner = Partner.find(partner_id)
      partner.update_token(access_token.to_json)

      flash.notice = 'Authorized successfully'
    rescue Exception => e
      flash.alert = 'Authorization failed'
    end

    redirect_to partners_path
  end


  private 

  def partner_params
    params.require(:partner).permit(:common_name, :access_email)
  end
end
