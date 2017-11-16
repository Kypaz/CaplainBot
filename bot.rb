require_relative 'parser'
require 'telegram/bot'
require 'parseconfig'
require 'digest/sha1'

config = ParseConfig.new('param.conf')

token = config['token']
$chat = config['chat']

Telegram::Bot::Client.run(token) do |bot|
  begin
  Thread.new do
    old_hash = 0
    while true do
      bulletin = get_bulletin()
      hash = Digest::SHA1.hexdigest(bulletin)
      if old_hash != hash
        new = "Nouveau bulletin ! \xF0\x9F\x98\x8C"
        result = new + "\n" + bulletin
        old_hash = hash
        bot.api.send_message(chat_id: $chat, text: result)
      else
      end
      sleep 60*60*4 #sleep4hours
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
  rescue Exception => e
    puts e.message
    puts e.backtrace.inspect
  end
end
