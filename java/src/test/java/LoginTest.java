import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class LoginTest {
    private WebDriver driver;

    @Before
    public void start() {
        driver = new ChromeDriver();
    }

    @Test
    public void loginTest() {
        driver.get("http://localhost/litecart/admin");
        driver.findElement(By.name("username")).sendKeys("admin");
        driver.findElement(By.name("password")).sendKeys("admin");
	driver.findElement(By.name("login")).click();
	
        String noticeText = driver.findElement(By.cssSelector(".notice.success")).getText();
	assertEquals(noticeText, "You are now logged in as admin");
    }

    @After
    public void stop() {
        driver.quit();
        driver = null;
    }
}
