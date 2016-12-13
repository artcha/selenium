var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing');

test.describe('Firefox', function() {
    var driver;

    test.before(function() {
	driver = new webdriver.Builder()
	    .forBrowser('firefox')
	    .build();
    });

    test.it('should change title', function() {
	driver.get('https://duckduckgo.com');
	driver.wait(until.titleIs('DuckDuckGo'), 1000);
    });

    test.after(function() {
	driver.quit();
    });
});

test.describe('Chrome', function() {
    var driver;

    test.before(function() {
	driver = new webdriver.Builder()
	    .forBrowser('chrome')
	    .build();
    });

    test.it('should change title', function() {
	driver.get('https://duckduckgo.com');
	driver.wait(until.titleIs('DuckDuckGo'), 1000);
    });

    test.after(function() {
	driver.quit();
    });
});
