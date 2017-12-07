require_relative 'parser'
require 'telegram/bot'
require 'parseconfig'
require 'dalli'
require 'digest/sha1'

config = ParseConfig.new('param.conf')

token = config['token']
$chat = config['chat']

options = { :namespace => "caplain", :compress => true }
$dc = Dalli::Client.new('localhost:11211', options)

Telegram::Bot::Client.run(token) do |bot|
  begin
    Thread.new do
      while true do
        bulletin = get_bulletin()
        hash = Digest::SHA1.hexdigest(bulletin)
        if ($dc.get('hash') == nil || $dc.get('hash') != hash)
          new = "Nouveau bulletin ! \xF0\x9F\x98\x8C"
          result = new + "\n" + bulletin
          $dc.set('hash',hash)
          bot.api.send_message(chat_id: $chat, text: result)
        else
        end
        sleep 60*60*2 #sleep2hours
      end
    end
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::Message
        case message.text
        when '/bulletin'
          puts(message.chat.id)
          bulletin = get_bulletin()
          bot.api.send_message(chat_id: message.chat.id, text: bulletin)
        end
      end
    end
  rescue Telegram::Bot::Exceptions::ResponseError => e
    puts e.message
    puts e.backtrace.inspect
    retry
  end
end
