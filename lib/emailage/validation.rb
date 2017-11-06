require "resolv"

module Emailage
  module Validation
    class << self
      
      def validate_email!(email)
        unless email =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
          raise ArgumentError, "#{email} is not a valid email address."
        end
      end
      
      def validate_ip!(ip)
        unless ((ip =~ Resolv::IPv4::Regex) || (ip =~ Resolv::IPv6::Regex))
          raise ArgumentError, "#{ip} is not a valid IP address."
        end
      end
      
      def validate_email_or_ip!(email_or_ip)
        if email_or_ip.is_a? Array
          if email_or_ip.size != 2
            raise ArgumentError, "an array must contain exactly one Email and one IP address. #{email_or_ip} is given."
          end
          validate_email! email_or_ip.first
          validate_ip! email_or_ip.last
        else
          regex_union = Regexp.union(URI::MailTo::EMAIL_REGEXP, Resolv::IPv4::Regex, Resolv::IPv6::Regex)
          unless email_or_ip =~ regex_union
            raise ArgumentError, "#{email_or_ip} is neither a valid IP address nor a valid email address."
          end
        end
      end
      
    end
  end
end


    
