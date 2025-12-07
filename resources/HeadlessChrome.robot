*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    BuiltIn
Library    OperatingSystem

*** Keywords ***
Open Headless Chrome
    [Arguments]    ${url}=https://demoqa.com
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Create WebDriver    Chrome    options=${options}
    Go To    ${url}
    Wait Until Page Contains Element    css:body    10s


Close Headless Chrome
    Close All Browsers
