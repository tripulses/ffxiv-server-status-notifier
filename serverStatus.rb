require 'net/http'
require 'uri'
require 'json'
require 'mail'

SERVER_NAME = '<server name>'

emailSender = '<sender email>'
emailRecipients = '<recipient emails'
appPassword = '<app password>'

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => emailSender,
            :password             => appPassword,
            :authentication       => 'plain',
            :enable_starttls_auto => true  }
            
def check_status
    serverName = '<server name>'

    uri = URI.parse('https://frontier.ffxiv.com/worldStatus/current_status.json')
    response = JSON.parse("#{Net::HTTP.get(uri)}")
        
    return response["#{SERVER_NAME}"]
end

server_status = check_status
puts "Checking #{SERVER_NAME} status..."

#3 = server is down
while server_status == 3 do 
    server_status = check_status
end

Mail.defaults do
  delivery_method :smtp, options
end

Mail.deliver do
       to emailRecipients
     from emailSender
  subject "#{SERVER_NAME} is up!'"
     body 'Server up!'
end
