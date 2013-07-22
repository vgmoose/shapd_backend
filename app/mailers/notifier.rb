class Notifier < ActionMailer::Base
    default from: "Shapd Team <Shapd@shapd.co>"
    
    def welcome(recipient)
        @account = recipient
        mail(:to => @account, :subject => "Thanks for Signing Up!").deliver
        
        mail(:to => "rickyayoub@gmail.com", :subject => "New Shapd user") do |format|
            format.html{render text: @account+" signed up for email notifications"}
        end.deliver
    end
    
    def custom(recipient, title, header, message)
        encrypt_email = Base64.encode64(recipient)
        
        @content = message.gsub("[DEMO APP LINK]", "https://shapd.co/demo/?a="+encrypt_email)
        @subtitle = header.gsub("[DEMO APP LINK]", "https://shapd.co/demo/?a="+encrypt_email)
        
        title = title.gsub("[DEMO APP LINK]", "https://shapd.co/demo/?a="+encrypt_email)
        
        mail(to: recipient, subject: title).deliver
        logger.info("sent "+title+" mail to " + recipient)
    end
end
