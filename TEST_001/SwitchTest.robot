*** Settings ***
Library     Browser    auto_closing_level=TEST


*** Variables ***
${Base_URL}             https://demo.automationtesting.in
${NewTabbed}            //a[contains(@data-toggle, "tab") and text()="Open New Tabbed Windows "]
${NewSeperate}          //a[contains(@data-toggle, "tab") and text()="Open New Seperate Windows"]
${SeperateMultiple}     //a[contains(@data-toggle, "tab") and text()="Open Seperate Multiple Windows"]


*** Test Cases ***
Switch Between Two Browsers
    New Browser    chromium    headless=False    args=["--start-maximized"]
    New Context    viewport=None
    New Page    ${Base_URL}
    Go To    ${Base_URL}/Windows.html
    Wait For Load State    load    timeout=10s

    ${log}    Get Browser Catalog
    Log To Console    ${log}
    ${Browser1}    Set Variable    ${log[0]['contexts'][0]['id']}

    New Browser    chromium    headless=False    args=["--start-maximized"]
    New Context    viewport=None
    New Page    ${Base_URL}
    Go To    ${Base_URL}/Alerts.html
    Wait For Load State    load    timeout=10s

    ${log2}    Get Browser Catalog
    Log To Console    ${log2}
    ${Browser2}    Set Variable    ${log2[0]['contexts'][1]['id']}
    Log To Console    ----------------------- 1 : ${Browser1}
    Log To Console    ----------------------- 2 : ${Browser2}

    Switch Context    id=${Browser1}
    Switch Context    id=${Browser2}
    Close Context    ACTIVE
