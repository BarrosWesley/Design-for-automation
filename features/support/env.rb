require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require 'clipboard'
require_relative 'helper.rb'

#criei uma constante para setar os ambientes
#ENVIRONMENT_TYPE = ENV['ENVIRONMENT_TYPE']
HEADLESS = ENV['HEADLESS']
ENVIRONMENT_TYPE = ENV['ENVIRONMENT_TYPE']

#criei uma variavel config para pegar a variavel de ambiente ENVIRONMENT_TYPE
# e to dizendo qual arquivo carregar atravez do ENVIRONMENT_TYPE
CONFIG = YAML.load_file(File.dirname(__FILE__) +
"/ambiente/#{ENVIRONMENT_TYPE}.yml")
World(Helper)

#Capybara.register_driver :selenium do |app|
#  option = ::Selenium::WebDriver::Chrome::Options.new
#  option.args << '--start-fullscreen'
#  option.args << '--disable-infobars'
#  Capybara::Selenium::Driver.new(app, browser: :chrome, options: option)
#end

Capybara.register_driver :selenium do |app|

  if HEADLESS.eql?('sem_headless')
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => { 'args' => ['--disable-infobars',
                                        'window-size=1600,1024'] }
      )
    )
  elsif HEADLESS.eql?('com_headless')
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => { 'args' => ['headless', 'disable-gpu',
                                        '--disable-infobars',
                                        'window-size=1600,1024'] }
      )
    )
  end
  end

Capybara.configure do |config|
  config.default_driver = :selenium
  config.app_host = CONFIG['url']

  Capybara.default_max_wait_time = 20
end