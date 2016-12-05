var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing'),
    should = require('should');

test.describe('Log in', function() {
    var driver;

    test.before(function() {
	driver = new webdriver.Builder()
	    .forBrowser('chrome')
	    .build();
    });

    test.it('should display notice', function() {
	driver.get('http://localhost/litecart/admin');
	driver.findElement(By.name('username')).sendKeys('admin');
	driver.findElement(By.name('password')).sendKeys('admin');
	driver.findElement(By.name('login')).click();
	return driver.findElement(By.className('notice success'))
	    .getText()
	    .should.be.eventually.equal('You are now logged in as admin');
    });

    test.after(function() {
	driver.quit();
    });
});
