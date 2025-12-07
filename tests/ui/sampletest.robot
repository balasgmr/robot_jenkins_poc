*** Settings ***
Library    SeleniumLibrary
Resource   ../../resources/HeadlessChrome.robot

Suite Setup       Open Headless Chrome
Suite Teardown    Close All Browsers

*** Variables ***
${URL}    https://demoqa.com/text-box

*** Test Cases ***
Textbox Form Submission
    [Documentation]    Fill the TextBox form and submit
    Input Text    id:userName    Bala Sugumar
    Input Text    id:userEmail   bala@example.com
    Input Text    id:currentAddress    Test Address
    Input Text    id:permanentAddress  Permanent Address
    Click Button  id:submit
    Page Should Contain Element   xpath://div[contains(text(),'Bala Sugumar')]
