require 'rspec'
require 'selenium-webdriver'

FRONT_PAGE_URL = 'http://localhost/litecart'

describe 'cart' do
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
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

  def open_product(already_opened, not_available)
    available_products = @driver.find_elements(:css, 'li.product a.link')

    available_products.each do |el|
      ref = el.attribute('href')

      if !already_opened.include?(ref) && !not_available.include?(ref)
        el.click

        stock_status = @driver.find_element(:css, 'div.stock-status span.value').text

        result = if stock_status == 'Sold out'
          {sold_out: ref}
        else
          {opened: ref}
        end

        return result
      end
    end

    raise 'Unable to find product'
  end

  def get_first_option_value(select_el)
    select_el.find_element(:css, 'option:not([value=""])').attribute('value')
  end

  def pick_first_option(select_el)
    val = get_first_option_value(select_el)
    @driver.execute_script("arguments[0].value=\"#{val}\"", select_el)
  end

  def add_to_cart
    if element_exists?(@driver, 'td.options span.required')
      size_field = @driver.find_element(:css, 'select[name="options[Size]"]')
      pick_first_option(size_field) 
    end
    
    @driver.find_element(:css, 'button[name=add_cart_product]').click
  end

  def get_quantity
    @driver.find_element(:css, 'div#cart span.quantity').text.to_i
  end

  def open_front_page
    if @driver.current_url != FRONT_PAGE_URL
      @driver.navigate.to FRONT_PAGE_URL
    end
  end

  def open_cart
    @driver.find_element(:xpath, '//div[@id="cart"]/a[text()[contains(.,"Checkout")]]').click
  end

  def get_items_qty
    @driver.find_elements(:css, 'table.dataTable td.item').length
  end

  def remove_first_item
    rows_before = get_items_qty

    if rows_before > 1
      @driver.find_element(:css, 'li.shortcut a').click
    end

    @driver.find_element(:css, 'button[name=remove_cart_item]').click
    @wait.until { get_items_qty == rows_before - 1}
  end

  it 'should add products to cart' do
    open_front_page

    opened_products = []
    not_available = []

    while opened_products.length < 3 do
      open_front_page
      product = open_product(opened_products, not_available)
      
      if product[:sold_out]
        not_available << product[:sold_out]
        next
      end

      opened_products << product[:opened]

      qty_before = get_quantity
      add_to_cart
      @wait.until { get_quantity == qty_before + 1}
    end

    open_cart

    while get_items_qty > 0 do
      remove_first_item
    end
  end
      
  after(:each) do
    @driver.quit
  end
end
