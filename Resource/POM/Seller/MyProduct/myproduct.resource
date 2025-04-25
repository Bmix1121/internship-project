*** Settings ***
Library     Browser


*** Variables ***
${ProductMenu}          //*[@data-test-id="Products"]
${OutofstockMenu}       //*[@data-test-id="Outofstock"]
${NotShowMenu}          //*[@data-test-id="Draft"]
${AddNewProductBtn}     //button[@data-test-id="AddNewProduct"]
${MyProduct}            //div[@data-test-id="MyProduct"]
${PageBack}             //div[@data-test-id="PageBackBtn"]
${LoadBtn}              //button[@data-test-id="loadBtn"]


*** Keywords ***
Validation : product
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    5
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//div[text()="${productname}"]    state=visible    timeout=1s
        IF    ${KW} == ${True}
            Click    //div[text()="${productname}"]
            BREAK
        ELSE
            Click    ${LoadBtn}
            Scroll By    selector=//section    vertical=10000
        END
    END
    IF    ${KW} == ${False}
        Fail    msg=Product "${productname}" Is Not Found!!
    END

Validation : no product
    ${text}=    Get Text    //p[contains(@class, 'text-slate-400 mt-5 text-xl')]
    Should Be True    "${text}" == "No product"

Click My Product
    Click    ${MyProduct}

Click Out of Stock Menu
    Click    ${OutofstockMenu}

Click Not Show Menu
    Click    ${NotShowMenu}

Click Pageback
    Click    ${PageBack}

Click Add new product
    Click    ${AddNewProductBtn}
