require 'net/http'
require 'uri'
require 'json'
require 'mail'

serverName = '<server name>'
emailSender = '<sender email>'
emailRecipients = '<recipient emails'
appPassword = '<app password>'
def check_status
    uri = URI.parse('https://frontier.ffxiv.com/worldStatus/current_status.json')
      response = JSON.parse("#{Net::HTTP.get(uri)}")
        return response['#{serverName}']
end

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :user_name            => emailSender,
            :password             => appPassword,
            :authentication       => 'plain',
            :enable_starttls_auto => true  }
            
tonberry_status = check_status
puts 'Checking ' +serverName+ ' status...'

while tonberry_status == 3 do 
    tonberry_status = check_status
end

Mail.defaults do
  delivery_method :smtp, options
end

Mail.deliver do
       to emailRecipients
     from emailSender
  subject +serverName+ ' is up!'
     body 'Server up!'
end
