*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # Safe flags for Chrome inside Docker/Jenkins
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --disable-software-rasterizer
    Call Method    ${options}    add_argument    --remote-debugging-port=9222
    Call Method    ${options}    add_argument    --window-size=1920,1080

    # Launch Chrome using Selenium 4+
    Create WebDriver    Chrome    options=${options}
