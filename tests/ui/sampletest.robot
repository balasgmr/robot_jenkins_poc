*** Settings ***
Resource    ../../resources/HeadlessChrome.robot
Suite Setup    Open Headless Chrome
Suite Teardown    Close All Browsers


*** Variables ***
${URL}    https://demoqa.com

*** Test Cases ***
Textbox Form Submission
    [Documentation]    Fill the TextBox form and submit
    Go To    ${URL}/text-box
    Input Text    id:userName    Bala Sugumar
    Input Text    id:userEmail   bala@example.com
    Input Text    id:currentAddress   Madurai
    Input Text    id:permanentAddress  Madurai
    Click Button    id:submit
    Page Should Contain    Bala Sugumar
    Page Should Contain    bala@example.com
