var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing');

test.describe('Search', function() {
    var driver;

    test.before(function() {
	driver = new webdriver.Builder()
	    .forBrowser('chrome')
	    .build();
    });

    test.it('should append query to title', function() {
	driver.get('https://duckduckgo.com');
	driver.findElement(By.name('q')).sendKeys('webdriver');
	driver.findElement(By.id('search_button_homepage')).click();
	driver.wait(until.titleIs('webdriver at DuckDuckGo'), 1000);
    });

    test.after(function() {
	driver.quit();
    });
});
