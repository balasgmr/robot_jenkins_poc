*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://example.com  # replace with your app URL

*** Keywords ***
Open Headless Chrome
    ${options}=    Evaluate    __import__('selenium.webdriver').ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --window-size=1920,1080
    Call Method    ${options}    add_argument    --remote-allow-origins=*

    ${driver_path}=    Evaluate    __import__('webdriver_manager.chrome').ChromeDriverManager().install()
    Create WebDriver    Chrome    options=${options}    executable_path=${driver_path}

    Go To    ${URL}

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Headless Chrome
    # Maximize Browser Window is optional in headless mode
    Wait Until Element Is Visible    id:my-select
    Select From List By Label        id:my-select    Two

    ${selected}=    Get Selected List Label    id:my-select
    Should Be Equal    ${selected}    Two

    Click Button    css:button
    Wait Until Page Contains    Received!

    Close Browser
