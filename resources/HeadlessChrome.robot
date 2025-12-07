*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Library    BuiltIn

*** Keywords ***
Open Headless Chrome
    [Arguments]    ${url}=None
    # Import ChromeOptions
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Headless mode (new) and additional args
    Call Method    ${options}    add_argument    headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080
    # Create WebDriver with options
    Create WebDriver    Chrome    options=${options}
    # If URL is passed, go to it
    Run Keyword If    ${url}    Go To    ${url}
    Wait Until Page Contains Element    css:body    10s

Close Headless Chrome
    [Documentation]    Closes all Chrome browsers
    Close All Browsers
