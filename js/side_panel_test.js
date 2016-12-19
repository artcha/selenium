var webdriver = require('selenium-webdriver'),
    By = webdriver.By,
    until = webdriver.until,
    test = require('selenium-webdriver/testing');

test.describe('side panel test', function() {
    var driver;

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

    function extractInfo(l) {
	var text = l.findElement(By.css('span.name')).getText();
	var ref = l.getAttribute('href'); 

	return Promise.all([text, ref])
	    .then(([t, r]) => ({text: t, ref: r}));
    }
    
    function getAppList() {
	return driver.findElements(By.css('#box-apps-menu li#app- > a')).then(links => {
	    return Promise.all(links.map(extractInfo));
	});	    
    }

    function clickApps(apps) {
	for (var a of apps) {
	    driver.findElement(By.css('li#app- > a[href="' + a['ref'] + '"]')).click();
	    driver.findElement(By.css('h1')).getText().then(t => console.log(t));
	}
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
