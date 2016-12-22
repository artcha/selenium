require 'rspec'
require 'selenium-webdriver'

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

  def get_country_list
    @driver.find_elements(:css, 'table.dataTable tr.row')
  end

  def get_names(list)
    list.map {|row| row.find_element(:css, 'td:nth-of-type(5) a').text }
  end

  def get_zones(row)
    row.find_element(:css, 'td:nth-of-type(6)').text.to_i
  end

  def element_exists?(el, selector)
    result = true

    begin
      el.find_element(:css, selector)
    rescue Selenium::WebDriver::Error::NoSuchElementError
      result = false
    end

    result
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

  it 'countries should be sorted by name' do
    @driver.navigate.to 'http://localhost/litecart/admin/?app=countries&doc=countries'
    login

    country_list = get_country_list()
    names = get_names(country_list)

    expect(names).to eq(names.sort)

    countries_with_zones = country_list.select {|x| get_zones(x) > 0 }

    links_to_visit = countries_with_zones.map(&method(:get_link))

    links_to_visit.each do |link|
      @driver.get(link)
      zone_list = get_zone_list

      expect(zone_list).to eq(zone_list.sort)
    end
  end

  after(:each) do
    @driver.quit
  end
end
