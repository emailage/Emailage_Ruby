require_relative 'emailage/version'
require_relative 'emailage/signature'
require_relative 'emailage/validation'
require_relative 'emailage/client'

module Emailage
  FRAUD_CODES = {
    1 => 'Card Not Present Fraud',
    2 => 'Customer Dispute (Chargeback)',
    3 => 'First Party Fraud',
    4 => 'First Payment Default',
    5 => 'Identify Theft (Fraud Application)',
    6 => 'Identify Theft (Account Take Over)',
    7 => 'Suspected Fraud (Not Confirmed)',
    8 => 'Synthetic ID',
    9 => 'Other'
  }
  
  class Error < StandardError; end
end
