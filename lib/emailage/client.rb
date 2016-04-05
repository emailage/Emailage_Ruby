require 'typhoeus'
require 'uuid'
require 'json'

module Emailage
  class Client
    attr_reader :secret, :token, :hmac_key, :sandbox
    attr_accessor :raise_errors
  
    # @param secret [String] Consumer secret, e.g. SID or API key.
    # @param token  [String] Consumer OAuth token.
    # @param sandbox [Boolean] Whether to use a sandbox instead of a production server.
    #   Ensure the according secret and token are supplied.
    #
    # @note HMAC key is created according to Emailage docs rather than OAuth1 spec.
    #
    def initialize(secret, token, options={})
      @secret, @token = secret, token
      @sandbox = options.fetch :sandbox, false
      @raise_errors = options.fetch :raise_errors, false
      
      # @hmac_key = [@secret, @token].map {|e| CGI.escape(e)}.join '&'
      @hmac_key = @token + '&'
    end
    
    private
    
    # Basic request method utilized by #query and #flag.
    #
    # @param endpoint [String] Currently, either an empty string or "/flag".
    # @param params  [Hash] Non-general GET request params.
    #
    # @return [Hash] Original Emailage API's JSON body.
    #
    def request(endpoint, params)
      base_url = "https://#{@sandbox ? 'sandbox' : 'api'}.emailage.com/emailagevalidator"
      url = "#{base_url}#{endpoint}/"
      params = {
        :format => 'json', 
        :oauth_consumer_key => @secret,
        :oauth_nonce => UUID.new.generate,
        :oauth_signature_method => 'HMAC-SHA1',
        :oauth_timestamp => Time.now.to_i,
        :oauth_version => 1.0
      }.merge(params)
      
      res = Typhoeus.get url, :params => params.merge(:oauth_signature => Signature.create('GET', url, params, @hmac_key))
      
      # For whatever reason Emailage dispatches JSON with unreadable symbls at the start, like \xEF\xBB\xBF.
      json = res.body.sub(/^[^{]+/, '')
      JSON.parse json
    end
    
    public
    
    # Query a risk score information for the provided email address, IP address, or a combination.
    #
    # @param query [String | Array<String>] Email, IP or a tuple of (Email, IP).
    # @param params [Hash] Extra request params as in API documentation.
    # @option urid [String] User Defined Record ID.
    #   Can be used when you want to add an identifier for a query.
    #   The identifier will be displayed in the result.
    #
    def query(query, params={})
      query *= '+' if query.is_a? Array
      request '', params.merge(:query => query)
    end
    
    # Query a risk score information for the provided email address.
    # This method differs from #query in that it ensures that the string supplied is in rfc2822 format.
    #
    # @param email [String]
    # @param params [Hash] Extra request params as in API documentation.
    # @option urid [String] User Defined Record ID. See #query.
    #
    def query_email(email, params={})
      Validation.validate_email! email
      query email, params
    end
    
    # Query a risk score information for the provided IP address.
    # This method differs from #query in that it ensures that the string supplied is in rfc791 format.
    #
    # @param ip [String]
    # @param params [Hash] Extra request params as in API documentation.
    # @option urid [String] User Defined Record ID. See #query.
    #
    def query_ip_address(ip, params={})
      Validation.validate_ip! ip
      query ip, params
    end
    
    # Query a risk score information for the provided combination of an Email and IP address.
    # This method differs from #query in that it ensures that the strings supplied are in rfc2822 and rfc791 formats.
    #
    # @param email [String]
    # @param ip [String]
    # @param params [Hash] Extra request params as in API documentation.
    # @option urid [String] User Defined Record ID. See #query.
    #
    def query_email_and_ip_address(email, ip, params={})
      Validation.validate_email! email
      Validation.validate_ip! ip
      query [email, ip], params
    end
    
    
    # Mark an email address as fraud, good, or neutral.
    #
    # @param flag  [String] Either fraud, neutral, or good.
    # @param query [String] Email to be flagged.
    # @param fraud_code [Integer | String] Reason why the Email or IP is considered fraud. ID or name of the one of FRAUD_CODES options.
    #   E.g. 8 or "Syntethic ID" for Syntethic ID
    #   Required only if you flag something as fraud.
    # @see Emailage::FRAUD_CODES for the list of available reasons and their IDs.
    #
    def flag(flag, query, fraud_code=nil)
      flags = %w[fraud neutral good]
      unless flags.include? flag.to_s
        raise ArgumentError, "flag must be one of #{flags * ', '}. #{flag} is given."
      end
      
      Validation.validate_email! query
      
      query *= '+' if query.is_a? Array
      params = {:flag => flag, :query => query}
      
      if flag == 'fraud'
        unless (1..9).to_a.include? fraud_code
          raise ArgumentError, "fraud_code must be an integer from 1 to 9 corresponding to #{FRAUD_CODES.values*', '}. #{fraud_code} is given."
        end
        params[:fraudcodeID] = fraud_code
      end
      
      request '/flag', params
    end
    
    # Mark an email address as fraud.
    #
    # @param query [String] Email to be flagged.
    # @param fraud_code [Integer | String] Reason why the Email or IP is considered fraud. ID or name of the one of FRAUD_CODES options.
    #   E.g. 8 or "Syntethic ID" for Syntethic ID
    # @see Emailage::FRAUD_CODES for the list of available reasons and their IDs.
    #
    def flag_as_fraud(query, fraud_code)
      flag 'fraud', query, fraud_code
    end
    
    # Mark an email address as good.
    #
    # @param query [String] Email to be flagged.
    #
    def flag_as_good(query)
      flag 'good', query
    end
    
    # Unflag an email address that was marked as good or fraud previously.
    #
    # @param query [String] Email to be flagged.
    #
    def remove_flag(query)
      flag 'neutral', query
    end
  
  end
end
