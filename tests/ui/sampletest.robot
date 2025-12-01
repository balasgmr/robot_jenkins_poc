*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://demoqa.com

*** Keywords ***
# ---------------------------------------------------------
# Open Browser at Home Page (Headless)
# ---------------------------------------------------------
Open Headless Browser
    ${options}=    Evaluate    __import__('selenium.webdriver').webdriver.ChromeOptions()
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}

# ---------------------------------------------------------
# Open Browser To a Specific Page (Headless)
# Example: Open Headless Browser To    /text-box
# ---------------------------------------------------------
Open Headless Browser To
    [Arguments]    ${PATH}
    ${options}=    Evaluate    __import__('selenium.webdriver').webdriver.ChromeOptions()
    Call Method    ${options}    add_argument    --headless=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}${PATH}

*** Test Cases ***

Textbox Form Submission
    Open Headless Browser To    /text-box
    Input Text    id:userName           Bala
    Input Text    id:userEmail          bala@example.com
    Input Text    id:currentAddress     Madurai
    Input Text    id:permanentAddress   India
    Execute JavaScript    document.querySelector("#submit").click()
    Page Should Contain    Bala
    Close Browser

Radio Button Test
    Open Headless Browser To    /radio-button
    Execute JavaScript    document.querySelector("label[for='yesRadio']").click()
    Page Should Contain    You have selected Yes
    Close Browser

Checkbox Test
    Open Headless Browser To    /checkbox
    Execute JavaScript    document.querySelector(".rct-checkbox").click()
    Page Should Contain    You have selected
    Close Browser
