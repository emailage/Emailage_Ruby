require './lib/emailage'

# Check if an email argument is provided
if ARGV.length != 1
  puts "Usage: ruby sampleRequest.rb <email>"
  exit
end

email = ARGV[0]
client = Emailage::Client.new('Consumer Key', 'Consumer Secret')
puts client.query(email)