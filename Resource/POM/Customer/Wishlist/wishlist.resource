*** Settings ***
Library     Browser


*** Variables ***
${BuyBtn}           //button[@data-test-id="BuyBtn"]
${PageBackBtn}      //div[@data-test-id="PageBackBtn"]
${LoadBtn}          //button[@data-test-id="loadBtn"]


*** Keywords ***
Select Product
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

Validation product has more than 0
    Click    ${BuyBtn}

Validation No products in the wishlist
    ${Text}=    Get Text    //p[@class="text-slate-400 mt-5 text-xl"]
    Should Be True    "${Text}" == "No Product"

Validation Product Out of Stock
    Click    ${BuyBtn}
    Wait For Elements State    //div[@data-test-id="OutofStockPopup"]
    Sleep    0.2s
    Click    //span[@data-test-id="CloseBtn"]

Validation : delete product
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    5
        ${loadBtncheck}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//button[@data-test-id="loadBtn"]    state=visible    timeout=2s
        IF    ${loadBtncheck} == ${True}
            Click    ${LoadBtn}
            Scroll By    selector=//section    vertical=10000
        ELSE
            BREAK
        END
    END
    Wait For Elements State    selector=//div[text()="${productname}"]    state=hidden    timeout=1s

Click Pageback
    Sleep    0.5s
    Click    ${PageBackBtn}
