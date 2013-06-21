class Notifier < ActionMailer::Base
    default from: "Shapd Team <Shapd@shapd.co>"
    
    def welcome(recipient)
        @account = recipient
        mail(:to => @account, :subject => "Thanks for Signing Up!").deliver
        
        mail(:to => "rickyayoub@gmail.com", :subject => "New Shapd user") do |format|
            format.html{render text: @account+" signed up for email notifications"}
        end.deliver
    end
end
