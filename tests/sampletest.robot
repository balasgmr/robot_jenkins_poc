*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser    https://example.com    chrome
Suite Teardown    Close Browser

*** Test Cases ***
Verify Page Title
    ${title}=    Get Title
    Log To Console    Page title is: ${title}
    Should Contain    ${title}    Example
