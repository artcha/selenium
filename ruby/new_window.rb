require 'rspec'
require 'selenium-webdriver'

def element_exists?(el, selector)
  result = true

  begin
    el.find_element(:css, selector)
  rescue Selenium::WebDriver::Error::NoSuchElementError
    result = false
  end

  result
end

class CountriesPage
  def initialize(drv)
    @driver = drv
  end

  def get_country_list
    @driver.find_elements(:css, 'table.dataTable tr.row')
  end

  def get_names(list)
    list.map {|row| row.find_element(:css, 'td:nth-of-type(5) a').text }
  end

  def get_zone_count(row)
    row.find_element(:css, 'td:nth-of-type(6)').text.to_i
  end

  def get_zone_list
    rows_with_zones = @driver.find_elements(:css, 'table#table-zones tr:not(.header)').select do |row|
      !element_exists?(row, 'button[name=add_zone]')
    end

    rows_with_zones.map do |row|
      row.find_element(:css, 'td:nth-of-type(3)').text
    end
  end

  def get_link(row)
    row.find_element(:css, 'td:nth-of-type(5) a').attribute('href')
  end
end

describe 'countries' do
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def login
    @driver.find_element(:name, 'username').send_keys('admin')
    @driver.find_element(:name, 'password').send_keys('admin')
    @driver.find_element(:name, 'login').click

    @wait.until { @driver.find_element(:css, '.notice.success') }
  end

  def open_first_country
    @driver.find_element(:css, 'table.dataTable tr.row td:nth-of-type(5) a').click
  end

  def get_external_links
    @driver.find_elements(:xpath, '//a/i[contains(@class, "fa-external-link")]/..')
  end
  
  it 'should open link in a new window' do
    @driver.navigate.to 'http://localhost/litecart/admin/?app=countries&doc=countries'
    login

    open_first_country
    this_window = @driver.window_handle

    get_external_links.each do |el|
      el.click

      @wait.until { @driver.window_handles.length > 1 }

      other_window = @driver.window_handles.find do |h|
        h != this_window
      end

      @driver.switch_to.window(other_window)
      @driver.close
      @driver.switch_to.window(this_window)
    end
  end

  after(:each) do
    @driver.quit
  end
end
