# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment') unless defined?(Rails)

require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'cucumber/rails/rspec'
require 'cucumber/rails/world'
require 'cucumber/web/tableish'

require 'capybara/rails'
require 'capybara/cucumber'
require 'capybara/session'
require 'cucumber/rails/capybara_javascript_emulation' # Lets you click links with onclick javascript handlers without using @culerity or @javascript
# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# If you set this to false, any error raised from within your app will bubble
# up to your step definition and out to cucumber unless you catch it somewhere
# on the way. You can make Rails rescue errors and render error pages on a
# per-scenario basis by tagging a scenario or feature with the @allow-rescue tag.
#
# If you set this to true, Rails will rescue all errors and render error
# pages, more or less in the same way your application would behave in the
# default production environment. It's not recommended to do this for all
# of your scenarios, as this makes it hard to discover errors in your application.
ActionController::Base.allow_rescue = false

require 'database_cleaner'
require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.orm = "active_record"
Cucumber::Rails::World.use_transactional_fixtures = false

require File.join(File.dirname(__FILE__), "database_cleaner_patches")

require File.join(File.dirname(__FILE__), "..", "..", "spec", "support", "fake_redis")
require File.join(File.dirname(__FILE__), "..", "..", "spec", "support", "receive_tokens_stub")
require File.join(File.dirname(__FILE__), "..", "..", "spec", "helper_methods")
require File.join(File.dirname(__FILE__), "..", "..", "spec", "support","user_methods")
include HelperMethods

Before do
  DatabaseCleaner.clean
  Devise.mailer.deliveries = []
end

silence_warnings do
  SERVICES['facebook'] = {'app_id' => :fake}
end

require File.join(File.dirname(__FILE__), "..", "..", "spec", "support", "fake_resque")
module Resque
  def enqueue(klass, *args)
    klass.send(:perform, *args)
  end
end

Before('@localserver') do
  TestServerFixture.start_if_needed
  CapybaraSettings.instance.save
  Capybara.current_driver = :selenium
  Capybara.run_server = false
end

After('@localserver') do
  CapybaraSettings.instance.restore
end

