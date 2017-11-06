require 'emailage'

# http://oauth.net/core/1.0/#sig_base_example
describe Emailage::Validation do
  let(:correct_email) {'test+emailage@example.com'}
  let(:incorrect_email) {'test+example.com'}
  let(:correct_ip) {'1.234.56.7'}
  let(:incorrect_ip) {'1.23.456.7890'}
  let(:correct_ip_v6) {'ff02::1'}
  let(:incorrect_ipv6) {'ff02::1::1'}
  let(:incorrect_ip_out_of_range) {'1.23.56.256'}
  
  subject {described_class}

  it 'validates an email address' do
    expect {subject.validate_email!   correct_email}.not_to raise_error
    expect {subject.validate_email! incorrect_email}.to raise_error ArgumentError
    expect {subject.validate_email!      correct_ip}.to raise_error ArgumentError
    expect {subject.validate_email!    incorrect_ip}.to raise_error ArgumentError
  end

  it 'validates an ip address' do
    expect {subject.validate_ip!   correct_email}.to raise_error ArgumentError
    expect {subject.validate_ip! incorrect_email}.to raise_error ArgumentError
    expect {subject.validate_ip!      correct_ip}.not_to raise_error
    expect {subject.validate_ip!    incorrect_ip}.to raise_error ArgumentError
    expect {subject.validate_ip!    incorrect_ip_out_of_range}.to raise_error ArgumentError

    expect {subject.validate_ip!   correct_ip_v6}.not_to raise_error
    expect {subject.validate_ip!   incorrect_ipv6}.to raise_error ArgumentError
  end

  it 'validates a tuple of email and ip address' do
    expect {subject.validate_email_or_ip! [correct_email,     correct_ip]}.not_to raise_error
    expect {subject.validate_email_or_ip! [incorrect_email,   correct_ip]}.to raise_error ArgumentError
    expect {subject.validate_email_or_ip! [correct_email,   incorrect_ip]}.to raise_error ArgumentError
    expect {subject.validate_email_or_ip! [incorrect_email, incorrect_ip]}.to raise_error ArgumentError
    expect {subject.validate_email_or_ip! [correct_email,     correct_ip, correct_ip]}.to raise_error ArgumentError
    expect {subject.validate_email_or_ip! [correct_email]}.to raise_error ArgumentError
  end

  it 'validates that string is either an email or an ip address' do
    expect {subject.validate_email_or_ip!   correct_email}.not_to raise_error
    expect {subject.validate_email_or_ip! incorrect_email}.to raise_error ArgumentError
    expect {subject.validate_email_or_ip!      correct_ip}.not_to raise_error
    expect {subject.validate_email_or_ip!    incorrect_ip}.to raise_error ArgumentError
  end

end