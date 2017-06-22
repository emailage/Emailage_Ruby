require 'emailage'

# http://oauth.net/core/1.0/#sig_base_example
describe Emailage::Signature do
  let(:method) {'GET'}
  let(:url) {'http://photos.example.net/photos'}
  let(:params) {{
    oauth_consumer_key: 'dpf43f3p2l4k3l03',
    oauth_token: 'nnch734d00sl2jdk',
    oauth_signature_method: 'HMAC-SHA1',
    oauth_timestamp: 1191242096,
    oauth_nonce: 'kllo9940pd9333jh',
    oauth_version: 1.0,
    file: 'vacation.jpg',
    size: 'orig inal'
  }}
  let(:hmac_key) {'kd94hf93k423kf44&pfkkdhi9sl3r4s00'}

  it 'normalizes query parameters' do
    query = Emailage::Signature.normalize_query_parameters(params)

    expect(query).to eq 'file=vacation.jpg&oauth_consumer_key=dpf43f3p2l4k3l03&oauth_nonce=kllo9940pd9333jh&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1191242096&oauth_token=nnch734d00sl2jdk&oauth_version=1.0&size=orig%20inal'
  end

  it 'generates base string' do
    query = Emailage::Signature.normalize_query_parameters(params)
    base_string = Emailage::Signature.concatenate_request_elements(method, url, query)

    expect(base_string).to eq 'GET&http%3A%2F%2Fphotos.example.net%2Fphotos&file%3Dvacation.jpg%26oauth_consumer_key%3Ddpf43f3p2l4k3l03%26oauth_nonce%3Dkllo9940pd9333jh%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1191242096%26oauth_token%3Dnnch734d00sl2jdk%26oauth_version%3D1.0%26size%3Dorig%2520inal'
  end

  it 'calculates signature value' do
    signature = Emailage::Signature.create(method, url, params, hmac_key)

    expect(signature).to eq 'NyW8+XlYYrIMfra1Wq/lHf8ru5g='
  end

end
