*** Settings ***
Library    SeleniumLibrary
Resource   headless_chrome.robot

*** Variables ***
${URL}    https://demoqa.com

*** Keywords ***
Open Headless Browser
    Open Headless Chrome
    Go To    ${URL}

Open Headless Browser To
    [Arguments]    ${PATH}
    Open Headless Chrome
    Go To    ${URL}${PATH}
    Wait Until Page Contains Element    css:body    10s

*** Test Cases ***

Textbox Form Submission
    Open Headless Browser To    /text-box
    Wait Until Element Is Visible    id:userName    10s
    Input Text    id:userName           Bala
    Input Text    id:userEmail          bala@example.com
    Input Text    id:currentAddress     Madurai
    Input Text    id:permanentAddress   India
    Scroll Element Into View    id:submit
    Click Button                id:submit
    Page Should Contain    Bala
    Close Browser

Radio Button Test
    Open Headless Browser To    /radio-button
    Wait Until Element Is Visible    css:label[for="yesRadio"]    10s
    Click Element                    css:label[for="yesRadio"]
    Page Should Contain              You have selected Yes
    Close Browser

Checkbox Test
    Open Headless Browser To    /checkbox
    Wait Until Element Is Visible    css:.rct-node .rct-checkbox    10s
    Scroll Element Into View         css:.rct-node .rct-checkbox
    Click Element                    css:.rct-node .rct-checkbox
    Page Should Contain              You have selected
    Close Browser
