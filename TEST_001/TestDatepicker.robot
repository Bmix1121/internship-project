*** Settings ***
Library         Browser    auto_closing_level=KEEP
Library         DateTime

Suite Setup     Set Up For test Datepicker


*** Variables ***
${Base_URL}     ...


*** Test Cases ***
Test01
    Seclect Date    2002-2-1


*** Keywords ***
Set Up For test Datepicker
    New Browser    browser=chromium    headless=False    args=["--start-maximized"]
    New Context    viewport=${None}
    New Page
    ...    url=${Base_URL}/access
    Fill Text    selector=//input[@name='name']    txt=...
    Fill Text    selector=//input[@name='password']    txt=...
    Click    selector=//button[contains(text(),'Login')]
    Wait For Navigation    url=${Base_URL}/welcome
    Go To    ${Base_URL}/account

Seclect Date
    [Documentation]    date format :
    [Arguments]    ${OpeningDate}
    ...    ${locator_datepicker}=(//*[@class="datepicker -bottom-left- -from-bottom- active"])

    ${currentDate}=    Get Current Date    result_format=datetime
    ${convertdate}=    Convert Date    ${OpeningDate}    date_format=%Y-%m-%d    result_format=datetime
    Log To Console    ${convertdate}
    ${date}=    Convert To Integer    ${convertdate.day}
    ${month}=    Set Variable    ${convertdate.month}
    ${year}=    Convert To Integer    ${convertdate.year}
    ${year_diff}=    Evaluate    ${year}-${currentDate.year}
    ${move}=    Evaluate    int(${year_diff}/10)

    ${monthEn}=    Set Variable If
    ...    ${month}==1    Jan
    ...    ${month}==2    Feb
    ...    ${month}==3    Mar
    ...    ${month}==4    Apr
    ...    ${month}==5    May
    ...    ${month}==6    Jun
    ...    ${month}==7    Jul
    ...    ${month}==8    Aug
    ...    ${month}==9    Sep
    ...    ${month}==10    Oct
    ...    ${month}==11    Nov
    ...    ${month}==12    Dec

    ${shiftForward}=    Set Variable If
    ...    ${move}==0    2
    ...    ${move}>0    1    # Right Arrow
    ...    ${move}<0    0    # Left Arrow

    ${move}=    Set Variable If
    ...    ${move}>0    ${move}
    ...    ${move}<0    ${move}*-1
    ...    ${move}==0    0

    Click    (//input[@class="form-control datepicker-here"])[1]
    Wait For Elements State    ${locator_datepicker}    visible    timeout=10s
    Click    (//div[@class="datepicker--nav-title"])[1]
    Click    (//div[@class="datepicker--nav-title"])[1]

    IF    ${shiftForward} != 2
        FOR    ${var}    IN RANGE    ${move}
            IF    ${shiftForward} == 0
                Click    (//div[@data-action="prev"])[1]
            END
            IF    ${shiftForward} == 1
                Click    (//div[@data-action="next"])[1]
            END
        END
    END
    # Select year
    Click    //div[@data-year="${year}"]
    # Select month
    Click    //div[text()="${monthEn}"]
    # Select date
    Click
    ...    (//div[contains(@class, 'datepicker--cell') and text() = '${date}'])[1]
