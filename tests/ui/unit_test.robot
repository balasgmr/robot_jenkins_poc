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
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Headless Chrome
    Maximize Browser Window

    # STEP 1: Select from dropdown
    Wait Until Element Is Visible    id:my-select
    Select From List By Label        id:my-select    Two

    # STEP 2: Verify selected value
    ${selected}=    Get Selected List Label    id:my-select
    Should Be Equal    ${selected}    Two

    # STEP 3: Click Submit
    Click Button    css:button

    # STEP 4: Validate next page
    Wait Until Page Contains    Received!

    Close Browser
