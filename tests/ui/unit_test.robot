*** Settings ***
Library    SeleniumLibrary
Resource   ../../resources/HeadlessChrome.robot

*** Variables ***
${URL}    https://demoqa.com/select-menu

*** Test Cases ***
Verify Dropdown And Continue Steps
    Open Headless Chrome
    Go To    ${URL}
    Wait Until Element Is Visible    xpath://select[@id='oldSelectMenu']    10s
    Select From List By Value        xpath://select[@id='oldSelectMenu']    2
    ${selected}=    Get Selected List Label    xpath://select[@id='oldSelectMenu']
    Should Be Equal    ${selected}    Saab
    Close Headless Chrome
