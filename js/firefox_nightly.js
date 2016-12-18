var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing'),
    should = require('should');

test.describe('Firefox Nightly', function() {
    var driver;

    test.before(function() {
	driver = new webdriver.Builder().withCapabilities({
	    'firefox_binary': '/home/artcha/tools/firefox_nightly/firefox'})
	    .forBrowser('firefox')
	    .build();
    });

    test.it('should have version 53.0a1', function() {
	driver.get('https://duckduckgo.com');
	driver.wait(until.titleIs('DuckDuckGo'), 1000);

	return driver.getCapabilities().then((caps) => {
	    caps.get('browserVersion').should.equal('53.0a1');
	})
    });

    test.after(function() {
	driver.quit();
    });
});

