# Emailage Ruby API Client

![alt text][logo]

[logo]: https://www.emailage.com/wp-content/uploads/2018/01/logo-dark.svg "Emailage Logo"

The Emailage&#8482; API is organized around REST (Representational State Transfer). The API was built to help companies integrate with our highly efficient fraud risk and scoring system. By calling our API endpoints and simply passing us an email and/or IP Address, companies will be provided with real-time risk scoring assessments based around machine learning and proprietary algorithms that evolve with new fraud trends.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'HornsAndHooves-emailage', require 'emailage'
```

And then execute:

``` bash
bundle
```

Or install it yourself as:

``` bash
gem install emailage
```

## Usage

Instantiate a client

```ruby
# For a production server
emailage = Emailage::Client.new('My account SID', 'My auth token')
# ... or for a sandbox
emailage = Emailage::Client.new('My account SID', 'My auth token', sandbox: true)
```

Query risk score information for the provided email address, IP address, or a combination

```ruby
# For an email address
emailage.query 'test@example.com'
# For an IP address
emailage.query '127.0.0.1'
# For a combination. Please note the order
emailage.query ['test@example.com', '127.0.0.1']
# Pass a User Defined Record ID.
# Can be used when you want to add an identifier for a query.
# The identifier will be displayed in the result.
emailage.query 'test@example.com', urid: 'My record ID for test@example.com'
```

Explicit methods produce the same request while validating format of the arguments passed

```ruby
# For an email address
emailage.query_email 'test@example.com'
# For an IP address
emailage.query_ip_address '127.0.0.1'
# For a combination. Please note the order
emailage.query_email_and_ip_address 'test@example.com', '127.0.0.1'
# Pass a User Defined Record ID
emailage.query_email_and_ip_address 'test@example.com', '127.0.0.1', urid: 'My record ID for test@example.com and 127.0.0.1'
```

Mark an email address as fraud, good, or neutral.
All the listed forms are possible.

When you mark an email as fraud, you must pass the fraudCodeId:
1 - "Card Not Present Fraud"
2 - "Customer Dispute (Chargeback)"
3 - "First Party Fraud"
4 - "First Payment Default"
5 - "Identify Theft (Fraud Application)"
6 - "Identify Theft (Account Take Over)"
7 - "Suspected Fraud (Not Confirmed)"
8 - "Synthetic ID"
9 - "Other"

```ruby
# Mark an email address as fraud.
emailage.flag 'fraud',   'test@example.com', 8
emailage.flag_as_fraud   'test@example.com', 8
# Mark an email address as good.
emailage.flag 'good',    'test@example.com'
emailage.flag_as_good    'test@example.com'
# Unflag an email address that was previously marked as good or fraud.
emailage.flag 'neutral', 'test@example.com'
emailage.remove_flag     'test@example.com'
```

### Exceptions

This gem can throw exceptions for any of the following issues:

1. When Curl has an issue and it's not possible to connect to the Emailage API
2. When improperly formatted JSON is received
3. When an incorrect email or IP address is passed to a flagging or explicitly querying method.
