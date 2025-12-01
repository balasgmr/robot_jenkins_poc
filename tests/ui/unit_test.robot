*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://www.selenium.dev/selenium/web/web-form.html

*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    __import__('selenium.webdriver').ChromeOptions()
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Headless Chrome
    Wait Until Element Is Visible    id:my-select
    Select From List By Label        id:my-select    Two
    ${selected}=    Get Selected List Label    id:my-select
    Should Be Equal    ${selected}    Two
    Click Button    css:button
    Wait Until Page Contains    Received!
    Close Browser
