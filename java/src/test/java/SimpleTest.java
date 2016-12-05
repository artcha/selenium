import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import static org.openqa.selenium.support.ui.ExpectedConditions.titleIs;

public class SimpleTest {
    private WebDriver driver;
    private WebDriverWait wait;

    @Before
    public void start() {
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, 10);
    }

    @Test
    public void searchTest() {
        driver.get("https://duckduckgo.com");
        driver.findElement(By.name("q")).sendKeys("webdriver");
        driver.findElement(By.id("search_button_homepage")).click();
        wait.until(titleIs("webdriver at DuckDuckGo"));
    }

    @After
    public void stop() {
        driver.quit();
        driver = null;
    }
}
