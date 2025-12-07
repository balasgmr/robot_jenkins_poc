*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections

*** Keywords ***
Open Headless Chrome
    [Arguments]    ${URL}=https://demoqa.com
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Fix: use --headless=new
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Create WebDriver    Chrome    chrome_options=${options}
    Go To    ${URL}

Close All Browsers
    Close All Browsers
