*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://example.com    # Replace with your app URL

*** Keywords ***
Open Headless Chrome Jenkins
    # Chrome Options
    ${options}=    Evaluate    __import__('selenium.webdriver').ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --remote-allow-origins=*
    Call Method    ${options}    add_argument    --window-size=1920,1080

    # Use webdriver_manager to auto-download compatible ChromeDriver
    ${driver_path}=    Evaluate    __import__('webdriver_manager.chrome').ChromeDriverManager().install()
    Create WebDriver    Chrome    options=${options}    executable_path=${driver_path}

    # Go to your app
    Go To    ${URL}

*** Test Cases ***
Verify Dropdown And Continue Steps Jenkins
    # Start Chrome in Jenkins-friendly headless mode
    Open Headless Chrome Jenkins

    Wait Until Element Is Visible    id:my-select
    Select From List By Label        id:my-select    Two

    ${selected}=    Get Selected List Label    id:my-select
    Should Be Equal    ${selected}    Two

    Click Button    css:button
    Wait Until Page Contains    Received!

    Close Browser
