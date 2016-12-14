# coding: utf-8
require 'rspec'
require 'selenium-webdriver'

describe 'Chrome search' do
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'should find webdriver' do
    @driver.navigate.to 'http://duckduckgo.com'

    element = @driver.find_element(:name, 'q')
    @wait.until { @driver.title == 'DuckDuckGo'}
  end

  after(:each) do
    @driver.quit
  end
end

describe 'Firefox search' do
  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'should find webdriver' do
    @driver.navigate.to 'http://duckduckgo.com'

    element = @driver.find_element(:name, 'q')
    @wait.until { @driver.title == 'DuckDuckGo'}
  end

  after(:each) do
    @driver.quit
  end
end

describe 'Internet Explorer search' do
  before(:each) do
    @driver = Selenium::WebDriver.for :internet_explorer
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  it 'should find webdriver' do
    @driver.navigate.to 'http://duckduckgo.com'

    element = @driver.find_element(:name, 'q')
    @wait.until { @driver.title == 'DuckDuckGo'}
  end

  after(:each) do
    @driver.quit
  end
end
