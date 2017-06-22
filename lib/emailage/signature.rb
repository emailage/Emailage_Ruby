require 'cgi'
require 'openssl'
require 'base64'

module Emailage
  module Signature
    class << self

      # 9.1.1.  Normalize Request Parameters
      def normalize_query_parameters(params)
        params.sort.map {|k,v| [CGI.escape(k.to_s), ERB::Util.url_encode(v.to_s)].join '='}.join '&'
      end

      # 9.1.3.  Concatenate Request Elements
      def concatenate_request_elements(method, url, query)
        [method.to_s.upcase, url, query].map {|e| CGI.escape(e)}.join '&'
      end

      # 9.2.  HMAC-SHA1
      def hmac_sha1(base_string, hmac_key)
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha1'), hmac_key, base_string)
      end

      # http://oauth.net/core/1.0/#signing_process
      # Using HTTP GET parameters option.
      #
      # @param method [String] HTTP 1.1 Method
      # @param url [String] Normalized URL to be requested until ? sign.
      # @param params [Hash] GET or www-urlencoded POST request params.
      # @param hmac_key  [String] Key generated out of Consumer secret and token.
      #
      # @return [String] Value of the oauth_signature query parameter.
      #
      def create(method, url, params, hmac_key)
        query = normalize_query_parameters(params)
        base_string = concatenate_request_elements(method, url, query)
        digest = hmac_sha1(base_string, hmac_key)
        # 9.2.1.  Generating Signature
        Base64.strict_encode64 digest
      end

    end
  end
end
