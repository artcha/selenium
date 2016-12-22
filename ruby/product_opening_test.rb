require 'rspec'
require 'selenium-webdriver'

class FrontPage
  def initialize(drv)
    @driver = drv
  end

  def get_product
    @driver.find_element(:css, 'div#box-campaigns li.product')
  end

  def get_name(product)
    product.find_element(:css, 'div.name').text
  end
end

class ProductPage
  def initialize(drv)
    @driver = drv
  end

  def get_product
    @driver.find_element(:css, 'div#box-product')
  end
  
  def get_name(product)
    product.find_element(:tag_name, 'h1').text
  end

  def product_displayed?
    @driver.find_element(:css, 'div#box-product')
  end
end

describe 'products' do
  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
  end

  def get_regular_price(product)
    product.find_element(:css, 'div.price-wrapper s.regular-price')
  end

  def get_campaign_price(product)
    product.find_element(:css, 'div.price-wrapper strong.campaign-price')
  end

  def is_bold?(text)
    text.style('font-weight') == 'bold'
  end

  def is_striked_out?(text)
    text.style('text-decoration') == 'line-through'
  end

  def get_color(text)
    text.style('color')
  end

  it 'should open product page' do
    @driver.navigate.to 'http://localhost/litecart'
    fp = FrontPage.new(@driver)

    product1 = fp.get_product
    reg_price1 = get_regular_price(product1)
    camp_price1 = get_campaign_price(product1)

    expect(is_striked_out?(reg_price1)).to be true
    expect(get_color(reg_price1)).to eq('rgba(119, 119, 119, 1)')
    expect(is_bold?(camp_price1)).to be true
    expect(get_color(camp_price1)).to eq('rgba(204, 0, 0, 1)')

    front_page_product = {
      name: fp.get_name(product1),
      regular_price: reg_price1.text,
      campaign_price: camp_price1.text
    }
    
    product1.click
    pp = ProductPage.new(@driver)
    @wait.until { pp.product_displayed? }

    product2 = pp.get_product
    reg_price2 = get_regular_price(product2)
    camp_price2 = get_campaign_price(product2)

    expect(is_striked_out?(reg_price2)).to be true
    expect(get_color(reg_price2)).to eq('rgba(102, 102, 102, 1)')
    expect(is_bold?(camp_price2)).to be true
    expect(get_color(camp_price2)).to eq('rgba(204, 0, 0, 1)')

    product_page_product = {
      name: pp.get_name(product2),
      regular_price: reg_price2.text,
      campaign_price: camp_price2.text
    }
    
    expect(front_page_product).to eq(product_page_product)
  end

  after(:each) do
    @driver.quit
  end
end
