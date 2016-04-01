$:<<'./lib'

require 'emailage/version'
require 'emailage/signature'
require 'emailage/validation'
require 'emailage/client'

module Emailage
  FRAUD_CODES = Hash[[
    'Card Not Present Fraud',
    'Customer Dispute (Chargeback)',
    'First Party Fraud',
    'First Payment Default',
    'Identify Theft (Fraud Application)',
    'Identify Theft (Account Take Over)',
    'Suspected Fraud (Not Confirmed)',
    'Synthetic ID',
    'Other'
  ].each_with_index.map {|code, idx|
    [code, idx+1]
  }]
  
  class Error < StandardError; end
end