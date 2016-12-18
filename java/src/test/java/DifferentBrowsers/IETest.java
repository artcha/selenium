package differentBrowsers;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import static org.openqa.selenium.support.ui.ExpectedConditions.titleIs;

public class IETest {
    private WebDriver driver;
    private WebDriverWait wait;

    @Before
    public void start() {
        driver = new InternetExplorerDriver();
        wait = new WebDriverWait(driver, 10);
    }

    @Test
    public void searchTest() {
        driver.get("https://duckduckgo.com");
        wait.until(titleIs("DuckDuckGo"));
    }

    @After
    public void stop() {
        driver.quit();
        driver = null;
    }
}
