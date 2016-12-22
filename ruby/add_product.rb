require 'rspec'
require 'selenium-webdriver'

PRODUCT_NAME = 'Elephant'

describe 'products' do
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def login
    @driver.find_element(:name, 'username').send_keys('admin')
    @driver.find_element(:name, 'password').send_keys('admin')
    @driver.find_element(:name, 'login').click

    wait_for_notice('You are now logged in as admin')
  end

  def wait_for_notice(notice)
    @wait.until { @driver.find_element(:css, 'div.notice.success').text == notice }
  end

  def is_tab_active?(tab)
    find_tab(tab).style('font-weight') == 'bold'
  end

  def change_tab(tab)
    find_tab(tab).click
    @wait.until { is_tab_active?(tab) }
  end

  def find_tab(tab)
    @driver.find_element(:xpath, "//a[normalize-space(text()) = \"#{tab}\"]")
  end

  def get_option_value(select_el, opt_name)
    select_el.find_element(:xpath,
                           "//option[normalize-space(text()) = \"#{opt_name}\"]")
      .attribute('value')
  end

  def pick_option(select_el, name)
    val = get_option_value(select_el, name)
    @driver.execute_script("arguments[0].value=\"#{val}\"", select_el)
  end

  def get_products
    @driver.find_elements(:css, 'table.dataTable td:nth-of-type(3) a')
      .map {|el| el.text}
  end
  
  it 'should add product' do
    @driver.navigate.to 'http://localhost/litecart/admin/?app=catalog&doc=catalog'
    login

    @driver.find_element(:xpath, '//a[normalize-space(text()) = "Add New Product"]').click 
    @wait.until { @driver.find_element(:tag_name, 'h1').text == 'Add New Product' }

    @driver.find_element(:css, 'input[name="status"][value="1"]').click
    @driver.find_element(:css, 'input[name="name[en]"]').send_keys(PRODUCT_NAME)
    @driver.find_element(:css, 'input[name="product_groups[]"][value="1-3"]').click
    @driver.find_element(:css, 'input[name=quantity]').send_keys('10')

    change_tab('Information')
    
    manufacturer = @driver.find_element(:css, 'select[name=manufacturer_id]')
    pick_option(manufacturer, 'ACME Corp.')

    @driver.find_element(:css, 'div.trumbowyg-editor').send_keys('Small elephant')

    change_tab('Prices')

    purchase_price = @driver.find_element(:css, 'input[name=purchase_price]')
    purchase_price.clear
    purchase_price.send_keys('1000.0')

    currency = @driver.find_element(:css, 'select[name=purchase_price_currency_code]')
    pick_option(currency, 'US Dollars')

    price = @driver.find_element(:css, 'input[name="prices[USD]"')
    price.clear
    price.send_keys('2000.0')
    
    @driver.find_element(:css, 'button[name=save]').click
    wait_for_notice('Changes were successfully saved.')

    expect(get_products).to include(PRODUCT_NAME)
  end

  after(:each) do
    @driver.quit
  end
end
