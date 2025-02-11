require './lib/emailage'
client = Emailage::Client.new('Consumer Key', 'Consumer Secret')
puts client.query('test@example.com')