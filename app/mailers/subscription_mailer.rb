class SubscriptionMailer < ActionMailer::Base
  include SendGrid
  default from: "subscriptions@hackonauts.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_subscription.subject
  #
  def new_subscription(user, subscribable)
    @user = user 
    @subscribable = subscribable 

    mail to: user.email, subject: "Subscribed to #{subscribable.name} Updates"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_comment.subject
  #
  def new_comment(username, body, commentable)
    @username = username
    @body = body
    @commentable = commentable

    # mail to all the users subscribed to the thread when a new 
    # comment is posted
    sendgrid_recipients = []
    @commentable.subscriptions.each do |subscription|
      sendgrid_recipients << subscription.user.email
    end

    mail to: sendgrid_recipients,
         subject: "#{username} posted a comment to #{commentable.name}"
  end
end
