*** Settings ***
Library     Browser    auto_closing_level=TEST
Library     FakerLibrary


*** Variables ***
${Base_URL}     https://demo.automationtesting.in


*** Test Cases ***
Faker Test
    New Browser    browser=chromium    headless=False    args=["--start-maximized"]
    New Context    viewport=None
    New Page    ${Base_URL}
    Go To    url=${Base_URL}/Register.html

    ${FirstName} =    FakerLibrary.First Name Female
    Fill Text    //input[@placeholder="First Name"]    ${FirstName}
    ${LastName} =    FakerLibrary.Last Name Female
    Fill Text    //input[@placeholder="Last Name"]    ${LastName}
    ${Address} =    FakerLibrary.Street Address
    Fill Text    //*[@ng-model="Adress"]    ${Address}
    ${Email} =    FakerLibrary.Email
    Fill Text    //input[@ng-model="EmailAdress"]    ${Email}
    ${Phone} =    FakerLibrary.Basic Phone Number
    Fill Text    //input[@ng-model="Phone"]    ${Phone}
    Click    input[name="radiooptions"][value="FeMale"]
    Checkbox    Cricket    Hockey
    Select Languages    Dutch    Greek    Italian    Polish
    Select Options By    //select[@id="Skills"]    value    Programming
    Select Country    Japan
    Select Options By    //select[@id="yearbox"]    value    2010
    Select Options By    //select[@placeholder="Month"]    value    December
    Select Options By    //select[@id="daybox"]    value    10
    ${Password} =    FakerLibrary.Password
    Fill Text    //input[@id="firstpassword"]    ${Password}
    Fill Text    //input[@id="secondpassword"]    ${Password}

    ${log} =    Catenate
    ...    ${\n}- - - - - - - - - -
    ...    ${\n}Name : ${FirstName}    ${LastName}
    ...    ${\n}Address : ${Address}
    ...    ${\n}Email : ${Email}
    ...    ${\n}Phone : ${Phone}
    ...    ${\n}Password : ${Password}
    ...    ${\n}- - - - - - - - - -
    Log To Console    ${log}


*** Keywords ***
Checkbox
    [Arguments]    @{text}
    FOR    ${i}    IN    @{text}
        Check Checkbox    input[type="checkbox"][value="${i}"]
    END

Select Languages
    [Arguments]    @{text}
    Click    //div[@id="msdd"]
    FOR    ${i}    IN    @{text}
        Click    //*[contains(@class, "ui-corner-all") and text()="${i}"]
    END

Select Country
    [Arguments]    ${country}
    Click    //span[@class="select2-selection__arrow"]
    Fill Text    //input[@class="select2-search__field"]    ${country}
    Click    //*[contains(@class, "select2-results__option") and text()="${country}"]
