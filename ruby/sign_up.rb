require 'rspec'
require 'selenium-webdriver'

PASSWORD = 'some pass'
FIRST_NAME = 'Sergey'
LAST_NAME = 'Artushkevich'

describe 'new user' do
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def get_random_email
    time = Time.new
    time_part = "#{time.day}.#{time.month}.#{time.year}_#{time.hour}.#{time.min}.#{time.sec}"
    "art_#{time_part}@mail.ru"
  end

  def wait_for_notice(text)
    @wait.until { @driver.find_element(:css, 'div.notice.success').text == text}
  end

  def enter_email(email)
    @driver.find_element(:css, 'input[name=email]').send_keys(email)
  end

  def enter_password
    @driver.find_element(:css, 'input[name=password]').send_keys(PASSWORD)
  end

  def logout
    @driver.get('http://localhost/litecart/en/logout')
  end

  it 'should create new user' do
    @driver.navigate.to 'http://localhost/litecart/en/create_account'
    @wait.until { @driver.find_element(:tag_name, 'h1').text == 'Create Account' }
    email = get_random_email

    @driver.find_element(:css, 'input[name=firstname]').send_keys(FIRST_NAME)
    @driver.find_element(:css, 'input[name=lastname]').send_keys(LAST_NAME)
    @driver.find_element(:css, 'input[name=address1]').send_keys('Some street')
    @driver.find_element(:css, 'input[name=postcode]').send_keys('123456')
    @driver.find_element(:css, 'input[name=city]').send_keys('Some city')
    enter_email(email)
    @driver.find_element(:css, 'input[name=phone]').send_keys('+71234567890')
    enter_password
    @driver.find_element(:css, 'input[name=confirmed_password]').send_keys(PASSWORD)
    @driver.find_element(:css, 'input[name=newsletter]').click()
    @driver.find_element(:css, 'button[name=create_account]').click()
    wait_for_notice('Your customer account has been created.')
    
    logout
    wait_for_notice('You are now logged out.')

    enter_email(email)
    enter_password
    @driver.find_element(:css, 'button[name=login]').click()
    wait_for_notice("You are now logged in as #{FIRST_NAME} #{LAST_NAME}.")

    logout
    wait_for_notice('You are now logged out.')
  end
    
  after(:each) do
    @driver.quit
  end
end


