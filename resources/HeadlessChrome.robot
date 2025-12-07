*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Headless Chrome
    [Arguments]    ${URL}=https://demoqa.com
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Escape '=' so Robot Framework doesn't treat it as a named argument
    Call Method    ${options}    add_argument    --headless\=new
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    # Escape '=' in window-size as well
    Call Method    ${options}    add_argument    --window-size\=1920,1080
    # Use the modern `options` argument (older `chrome_options` is unsupported)
    Create WebDriver    Chrome    options=${options}
    Go To    ${URL}
    # Repeatedly remove ad overlays if they are injected after page load
    Execute JavaScript    var _id='adplus-anchor'; var _i=setInterval(function(){ var e=document.getElementById(_id); if(e){ e.remove(); clearInterval(_i); } },200);

Close All Browsers
    Run Keyword    SeleniumLibrary.Close All Browsers
