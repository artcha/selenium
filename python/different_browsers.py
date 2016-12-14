import pytest
from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

@pytest.fixture
def chrome_driver(request):
    wd = webdriver.Chrome()
    request.addfinalizer(wd.quit)
    return wd

def test_chrome(chrome_driver):
    chrome_driver.get("https://duckduckgo.com")
    WebDriverWait(chrome_driver, 10).until(EC.title_is("DuckDuckGo"))

@pytest.fixture
def ie_driver(request):
    wd = webdriver.Ie()
    request.addfinalizer(wd.quit)
    return wd

def test_ie(ie_driver):
    ie_driver.get("https://duckduckgo.com")
    WebDriverWait(ie_driver, 10).until(EC.title_is("DuckDuckGo"))

@pytest.fixture
def firefox_driver(request):
    wd = webdriver.Firefox()
    request.addfinalizer(wd.quit)
    return wd

def test_firefox(firefox_driver):
    firefox_driver.get("https://duckduckgo.com")
    WebDriverWait(firefox_driver, 10).until(EC.title_is("DuckDuckGo"))
