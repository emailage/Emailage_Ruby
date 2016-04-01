require 'emailage'

describe Emailage::Client do
  let(:t) {spy :typhoeus}
  let(:email) {'test+emailage@example.com'}
  let(:ip) {'1.234.56.7'}
  
  before {
    allow(t).to receive(:get) {double :response, :body => "\xEF\xBB\xBF{\"success\":[true]}"}
    stub_const 'Typhoeus', t
  }
  
  subject {described_class.new 'secret', 'token', true}

  it 'generates appropriate HMAC-SHA1 key' do
    expect(subject.hmac_key).to eq 'token&'
  end

  describe '#request' do
    let(:request) {subject.request '/endpoint', {:query => 'something'}}
  
    it 'targets requests to the correct endpoint with correct request params' do
      request
      expect(t).to have_received(:get).with\
        "https://sandbox.emailage.com/emailagevalidator/endpoint/",
        :params => a_hash_including(:query => 'something', :oauth_consumer_key => 'secret')
    end
  
    it 'parses response body as JSON' do
      expect(request).to eq 'success' => [true]
    end
  end

  describe '#query' do
    it 'concatenates arguments and passes extra params to request' do
      expect(subject).to receive(:request).with '',
        :urid => 1234567890,
        :query => 'test+emailage@example.com+1.234.56.7'
      
      subject.query [email, ip], :urid => 1234567890
    end
  end

  describe '#flag_as_good' do
    it 'flags a supplied address as good' do
      expect(subject).to receive(:request).with '/flag',
        :flag => 'good',
        :query => 'test+emailage@example.com'
        
      subject.flag_as_good email
    end
  end

  describe '#flag_as_fraud' do
    it 'flags a supplied address as fraud with an appropriate fraud code' do
      expect(subject).to receive(:request).with '/flag',
        :flag => 'fraud',
        :query => 'test+emailage@example.com+1.234.56.7',
        :fraudcodeID => 3
        
      subject.flag_as_fraud [email, ip], 'First Party Fraud'
    end
    
    it 'raises an error when unknown fraud code is supplied' do
      expect {subject.flag_as_fraud email}.to raise_error ArgumentError
      expect {subject.flag_as_fraud email, 'Blah blah'}.to raise_error ArgumentError
      expect {subject.flag_as_fraud email, 42}.to raise_error ArgumentError
    end
  end

  describe '#remove_flag' do
    it 'unflags a supplied address' do
      expect(subject).to receive(:request).with '/flag',
        :flag => 'neutral',
        :query => '1.234.56.7'
        
      subject.remove_flag ip
    end
  end

end