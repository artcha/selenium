require 'rspec'
require 'selenium-webdriver'

describe 'login' do
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
  end

  it 'should show login message' do
    @driver.navigate.to 'http://localhost/litecart/admin/'
    @driver.find_element(:name, 'username').send_keys('admin')
    @driver.find_element(:name, 'password').send_keys('admin')
    @driver.find_element(:name, 'login').click

    notice_text = @driver.find_element(:css, '.notice.success').text
    expect(notice_text).to eq('You are now logged in as admin')
  end

  after(:each) do
    @driver.quit
  end
end
