*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Call Method    ${options}    add_argument    --remote-debugging-port=9222

    # Use WebDriver Manager to get the correct ChromeDriver
    ${driver_path}=    Evaluate    __import__('webdriver_manager.chrome').ChromeDriverManager().install()    sys
    Create WebDriver    Chrome    chrome_options=${options}    executable_path=${driver_path}
