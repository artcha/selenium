# coding: utf-8
require 'rspec'
require 'selenium-webdriver'

describe 'DuckDuckGo search' do
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'should find webdriver' do
    @driver.navigate.to 'http://duckduckgo.com'

    element = @driver.find_element(:name, 'q')
    element.send_keys('webdriver')
    @driver.find_element(:id, 'search_button_homepage').click
    @wait.until { @driver.title == 'webdriver at DuckDuckGo'}
  end

  after(:each) do
    @driver.quit
  end
end
