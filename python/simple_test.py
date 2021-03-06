import pytest
from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

@pytest.fixture
def driver(request):
    wd = webdriver.Chrome()
    request.addfinalizer(wd.quit)
    return wd

def test_search(driver):
    driver.get("https://duckduckgo.com")
    driver.find_element_by_name("q").send_keys("webdriver")
    driver.find_element_by_id("search_button_homepage").click()
    WebDriverWait(driver, 10).until(EC.title_is("webdriver at DuckDuckGo"))
