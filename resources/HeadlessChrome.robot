*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections

*** Keywords ***
Open Headless Chrome
    [Arguments]    ${URL}=https://demoqa.com
    # Create ChromeOptions object
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Add headless & other args
    Call Method    ${options}    add_argument    headless
    Call Method    ${options}    add_argument    no-sandbox
    Call Method    ${options}    add_argument    disable-dev-shm-usage
    Call Method    ${options}    add_argument    disable-gpu
    Call Method    ${options}    add_argument    "window-size=1920,1080"
    # Start Chrome with options
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}
    Wait Until Page Contains Element    css:body    10s

