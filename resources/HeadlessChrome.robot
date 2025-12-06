*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    Process

*** Variables ***
${CHROME_DRIVER_VERSION}    latest

*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Call Method    ${options}    add_argument    --remote-debugging-port=9222

    # Use webdriver-manager to automatically fetch correct chromedriver
    ${chrome_p_
