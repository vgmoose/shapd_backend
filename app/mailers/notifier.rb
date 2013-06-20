class Notifier < ActionMailer::Base
  default from: "Shapd Team <Shapd@shapd.co>"
    
    def welcome(recipient)
        @account = recipient
        mail(:to => @account,
             :bcc => ["rickyayoub@gmail.com"]) 
    end
end
