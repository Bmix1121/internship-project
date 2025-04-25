*** Settings ***
Library     Browser


*** Variables ***
${SearchTxb}            //input[@data-test-id="SearchTxb"]
${AllProductBtn}        //button[@data-test-id="AllProduct"]
${RecommendBtn}         //button[@data-test-id="Recommend"]
${LastupBtn}            //button[@data-test-id="LastUpload"]
${BestsellingBtn}       //button[@data-test-id="Bestselling"]
${PageBack}             //*[@data-test-id="PageBackBtn"]
${LoadBtn}              //button[@data-test-id="loadBtn"]


*** Keywords ***
Select Product
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    10
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//div[text()="${productname}"]    state=visible    timeout=1s
        IF    ${KW} == ${True}
            Click    //div[text()="${productname}"]
            BREAK
        ELSE
            Click    ${LoadBtn}
            Sleep    0.5s
            Scroll By    selector=//section[2]    vertical=10000
        END
    END
    IF    ${KW} == ${False}
        Fail    msg=Product "${productname}" Is Not Found!!
    END

Fill Search
    [Documentation]
    ...    Product name or price
    [Arguments]    ${text}
    Fill Text    ${SearchTxb}    ${text}

Validation : Product out of stock
    [Arguments]    ${Productname}=RobotTest
    FOR    ${i}    IN RANGE    5
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State
        ...    //div[contains(@class, "mb-3 ")] [.//p[text()="สินค้าหมด"] and .//div[text()="${Productname}"]]
        ...    visible
        ...    1s
        IF    ${KW} == ${True}
            Click    //div[text()="${productname}"]
            BREAK
        ELSE
            Click    ${LoadBtn}
            Scroll By    selector=//section[2]    vertical=10000
        END
    END
    IF    ${KW} == ${False}
        Fail    msg=Product "${productname}" Is Not Found!!
    END

Select Product in recommend
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    10
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//div[text()="${productname}"]    state=visible    timeout=1s
        IF    ${KW} == ${True}
            Click    //div[text()="${productname}"]
            BREAK
        ELSE
            Click Recommend
        END
    END
    IF    ${KW} == ${False}
        Fail    msg=Product "${productname}" Is Not Found!!
    END

Validation : no product
    # Wait For Elements State    //p[contains(@class, "text-slate-400 mt-5 text-xl") and text()="No Product"]    visible    5s
    ${text}=    Get Text    //p[@class="text-slate-400 mt-5 text-xl"]
    Should Be True    "${text}" == "No Product"

Validation : draft product
    [Arguments]    ${productname}=RobotDraftTest
    ${isManu}=    Get Attribute
    ...    selector=//button[contains(@class, 'app-outline-btn') and contains(@class, 'active-btn')]
    ...    attribute=data-test-id
    IF    "${isManu}" == "Recommend"
        FOR    ${i}    IN RANGE    8
            Wait For Elements State    selector=//div[text()="${productname}"]    state=hidden    timeout=1s
            Click Recommend
        END
    ELSE IF    "${isManu}" == "AllProduct"
        FOR    ${i}    IN RANGE    5
            ${loadBtncheck}=    Run Keyword And Return Status
            ...    Wait For Elements State
            ...    selector=//button[@data-test-id="loadBtn"]
            ...    state=visible
            ...    timeout=1s
            IF    ${loadBtncheck} == ${True}
                Click    ${LoadBtn}
                Sleep    0.5s
                Scroll By    selector=//section[2]    vertical=10000
            ELSE
                BREAK
            END
        END
    END
    Wait For Elements State    selector=//div[text()="${productname}"]    state=hidden    timeout=3s

Click Pageback
    Sleep    0.2s
    Click    ${PageBack}

Click Recommend
    Click    ${RecommendBtn}

Click Last Upload
    Click    ${LastupBtn}

Click Best selling
    Click    ${BestsellingBtn}
