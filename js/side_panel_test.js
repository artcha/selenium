var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    until = webdriver.until,
    should = require('should'),
    test = require('selenium-webdriver/testing');

test.describe('side panel test', function() {
    var driver;
    this.timeout(30000);

    test.before(function() {
	driver = new webdriver.Builder()
	    .forBrowser('chrome')
	    .build();
    });

    function login() {
	driver.findElement(By.name('username')).sendKeys('admin');
	driver.findElement(By.name('password')).sendKeys('admin');
	driver.findElement(By.name('login')).click();
    }
    
    function getAppList() {
	return driver.findElements(By.css('#box-apps-menu li#app- > a')).then(links => {
	    return Promise.all(links.map(l => l.getAttribute('href')));
	});	    
    }

    function collectSublinks(link) {
	return driver.findElements(By.css('li#app-.selected li:not(.selected) > a'))
	    .then(items => Promise.all(items.map(i => i.getAttribute('href'))))
	    .then(clickSublinks);
    }

    function clickSublinks(links) {
	if (links.length == 0)
	    return undefined;

	var link = links[0];

	return driver.findElement(By.css('li > a[href="' + link + '"]')).click()
	    .then(() => driver.findElement(By.tagName('h1')).should.be.fulfilled)
	    .then(() => clickSublinks(links.slice(1)));
    }

    function clickApps(apps) {
	if (apps.length == 0)
	    return undefined;

	var link = apps[0];

	return driver.findElement(By.css('li#app- > a[href="' + link + '"]')).click()
	    .then(() => driver.findElement(By.tagName('h1')).should.be.fulfilled)
	    .then(() => collectSublinks(link))
	    .then(() => clickApps(apps.slice(1)));
    }

    test.it('should append query to title', function() {
	driver.get('http://localhost/litecart/admin');
	login();

	driver.wait(until.elementLocated(By.className('notice success')))
	    .then(getAppList)
	    .then(clickApps)	
    });

    test.after(function() {
	driver.quit();
    });
});
