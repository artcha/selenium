var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    test = require('selenium-webdriver/testing'),
    should = require('should');

test.describe('Log in', function() {
    var driver;

    test.before(function() {
	driver = new webdriver.Builder()
	    .forBrowser('chrome')
	    .build();
    });

    function getStickersCount(product) {
	return product.findElements(By.css('div.sticker'))
	    .then(stickers => Promise.resolve(stickers.length));
    }

    test.it('all products should have exactly 1 sticker', function() {
	driver.get('http://localhost/litecart');

	return driver.findElements(By.css('li.product'))
	    .then(products => Promise.all(
		products.map(p => getStickersCount(p).should.eventually.be.equal(1))
	    ));
    });

    test.after(function() {
	driver.quit();
    });
});
