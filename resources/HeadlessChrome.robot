*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    BuiltIn
Library    OperatingSystem

*** Keywords ***
Open Headless Chrome
    [Arguments]    ${url}=None
    # Get the correct ChromeOptions class from Selenium
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Add headless mode (works with recent Selenium/Chrome versions)
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080
    # Create WebDriver instance explicitly
    Create WebDriver    Chrome    options=${options}
    # Go to URL if provided
    Run Keyword If    ${url}    Go To    ${url}
    Wait Until Page Contains Element    css:body    10s

Close Headless Chrome
    Close All Browsers
