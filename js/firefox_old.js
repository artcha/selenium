var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing'),
    should = require('should');


test.describe('Firefox ESR', function() {
    var driver;

    test.before(function() {
	driver = new webdriver.Builder().withCapabilities({
	    'marionette': true,
	    'firefox_binary': '/home/artcha/tools/firefox_old/firefox'})
	    .forBrowser('firefox')
	    .build();
    });

    test.it('should have version 45.6.0', function() {
	driver.get('https://duckduckgo.com');
	driver.wait(until.titleIs('DuckDuckGo'), 1000);

	return driver.getCapabilities().then((caps) => {
	    caps.get('version').should.equal('45.6.0');
	})
    });

    test.after(function() {
	driver.quit();
    });
});
