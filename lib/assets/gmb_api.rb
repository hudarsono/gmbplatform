class GmbApi
  GMB_BASE_URL = "https://mybusiness.googleapis.com/#{GMB_API_VERSION}"

  GMB_OPERATIONS = {
    :list_accounts => {:method => :get, :uri => "#{GMB_BASE_URL}/accounts"},
    :get_account => {:method => :get, :uri => "#{GMB_BASE_URL}/{+name}"},
    :create_account_location => {:method => :post, :uri => "#{GMB_BASE_URL}/{+name}/locations"}
  }

  def initialize(client)
    @client = client
  end

  def call action, params={}
    # throw error if action is not recogniszed
    raise ArgumentError, "Action is not recognized" if !GMB_OPERATIONS.has_key?(action)
    call_params = GMB_OPERATIONS[action]

    # if account name is required
    if call_params[:uri].include?("{+name}")
      raise ArgumentError, "Account name is required" if params[:account_name].nil?
      call_params[:uri].gsub!("{+name}", params[:account_name])
    end

    # provide post data for method :post
    if call_params[:method] == :post
      call_params[:body] = params[:body]
    end

    execute_api call_params
  end

  private 

  def execute_api call_params
    begin
      res = @client.fetch_protected_resource(call_params)
      eval(res.body)
    rescue Exception => e 
      raise "GMB API call error : #{e.inspect}"
    end
  end

end