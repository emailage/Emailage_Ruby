module Emailage
  module Validation
    class << self
      
      def validate_email!(email)
        unless email =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
          raise ArgumentError, "#{email} is not a valid email address."
        end
      end
      
      def validate_ip!(ip)
        unless ip =~ /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/
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
          unless email_or_ip =~ /\A([^@\s]+@([^@\s]+\.)+[^@\s]+|\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\z/
            raise ArgumentError, "#{email_or_ip} is neither a valid IP address nor a valid email address."
          end
        end
      end
      
    end
  end
end