*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://www.selenium.dev/selenium/web/web-form.html

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Browser    ${URL}    chrome
    Maximize Browser Window

    # STEP 1: Select from dropdown
    Wait Until Element Is Visible    id:my-select
    Select From List By Label        id:my-select    Two

    # STEP 2: Verify selected value
    ${selected}=    Get Selected List Label    id:my-select
    Should Be Equal    ${selected}    Two

    # STEP 3: Click Submit
    Click Button    css:button

    # STEP 4: Validate next page or message
    Wait Until Page Contains    Received!

    Close Browser
