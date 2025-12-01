*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${URL}    https://www.selenium.dev/selenium/web/web-form.html

*** Keywords ***
Open Headless Chrome
    # Configure Chrome Options for Jenkins/Linux
    ${options}=    Evaluate    __import__('selenium.webdriver').ChromeOptions()
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size=1920,1080

    # Use webdriver-manager to get matching ChromeDriver
    ${driver}=    Evaluate    __import__('webdriver_manager.chrome').ChromeDriverManager().install()

    # Create WebDriver instance
    Create WebDriver    Chrome    options=${options}    executable_path=${driver}

    # Navigate to URL
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
