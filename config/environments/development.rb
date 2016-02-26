mailer_regex = /config\.action_mailer\.raise_delivery_errors = false\n/

comment_lines "config/environments/development.rb", mailer_regex
insert_into_file "config/environments/development.rb", :after => mailer_regex do
  <<-RUBY

  # Mailer options.
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  config.action_mailer.asset_host = "http://localhost:3000"
  RUBY
end

bullet_regex = /# config\.action_view\.raise_on_missing_translations = true\n/
insert_into_file "config/environments/development.rb", :after => bullet_regex do
  <<-RUBY
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
    Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
    Bullet.stacktrace_excludes = [ 'their_gem', 'their_middleware' ]
    #Bullet.slack = { webhook_url: 'http://some.slack.url', foo: 'bar' }
    #Bullet.honeybadger = true
    #Bullet.bugsnag = true
    #Bullet.airbrake = true
    #Bullet.rollbar = true
    #Bullet.growl = true
    #Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
                    #:password => 'bullets_password_for_jabber',
                    #:receiver => 'your_account@jabber.org',
                    #:show_online_status => true }
  end
  RUBY
end
