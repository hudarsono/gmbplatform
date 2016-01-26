class GmbApi
  GMB_BASE_URL = "https://mybusiness.googleapis.com/#{GMB_API_VERSION}"

  GMB_OPERATIONS = {
    :list_accounts => {:method => :get, :uri => "#{GMB_BASE_URL}/accounts"},
    :get_account => {:method => :get, :uri => "#{GMB_BASE_URL}/{+acc_name}"},
    :create_account_location => {:method => :post, :uri => "#{GMB_BASE_URL}/{+acc_name}/locations"},
    :list_account_locations => {:method => :get, :uri => "#{GMB_BASE_URL}/{+acc_name}/locations"},
    :get_account_location => {:method => :get, :uri => "#{GMB_BASE_URL}/{+acc_name}/locations/{+loc_name}"},
    :delete_account_location => {:method => :delete, :uri => "#{GMB_BASE_URL}/{+acc_name}/locations/{+loc_name}"},
    :update_account_location => {:method => :patch, :uri => "#{GMB_BASE_URL}/{+acc_name}/locations/{+loc_name}"}
  }

  def initialize(client,params=nil)
    @client = client
    @params = params
    @api_params = {}
  end

  def set_params params 
    @params = params
  end

  def get_params 
    @params
  end

  def call action
    # throw error if action is not recogniszed
    raise ArgumentError, "Action is not recognized" if !GMB_OPERATIONS.has_key?(action)
    @api_params = GMB_OPERATIONS[action]

    construct_call_paramters

    execute_api
  end

  private 

  def execute_api
    begin
      res = @client.fetch_protected_resource(@api_params)
      eval(res.body)
    rescue Exception => e 
      raise "GMB API call error : #{e.inspect}"
    end
  end

  def construct_call_paramters
    insert_account_name_to_uri

    insert_location_name_to_uri

    insert_payload
  end

  def insert_account_name_to_uri
    if @api_params[:uri].include?("{+acc_name}")
      raise ArgumentError, "params[:account_name] is required" if @params[:account_name].blank?
      @api_params[:uri].gsub!("{+acc_name}", @params[:account_name])
    end
  end

  def insert_location_name_to_uri
    if @api_params[:uri].include?("{+loc_name}")
      raise ArgumentError, "params[:location_name] is required" if @params[:location_name].blank?
      @api_params[:uri].gsub!("{+loc_name}", @params[:location_name])
    end
  end

  def insert_payload
    if [:post, :patch].include? @api_params[:method]
      raise ArgumentError, "params[:body] is required" if @params[:body].blank?
      @api_params[:body] = @params[:body]
    end
  end

end