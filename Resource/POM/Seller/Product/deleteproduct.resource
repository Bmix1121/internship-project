*** Settings ***
Library     Browser


*** Variables ***
${Ellipsis}         (//*[@data-test-id="EllipsisBtn"])[1]
${DeleteBtn}        //button[@data-test-id="DelproductBtn"]
${DeletePopup}      //*[@data-test-id="DeletePopup"]
${DelConfirmBtn}    //button[@data-test-id="DelconfirmBtn"]
${DelCancelBtn}     //button[@data-test-id="DelcancelBtn"]

${Products}         //li[@data-test-id="Products"]
${OutofStock}       //li[@data-test-id="Outofstock"]
${Draft}            //li[@data-test-id="Draft"]

${PageBackBtn}      //div[@data-test-id="PageBackBtn"]
${LoadBtn}          //button[@data-test-id="loadBtn"]


*** Keywords ***
Delete Product
    [Arguments]    ${text}
    IF    "${text}" == "Confirm"
        Click    ${DeleteBtn}
        Wait For Elements State    ${DeletePopup}    visible    3s
        Click    ${DelConfirmBtn}
    ELSE IF    "${text}" == "Cancel"
        Click    ${DeleteBtn}
        Wait For Elements State    ${DeletePopup}    visible    3s
        Click    ${DelCancelBtn}
    END

Validation : Delete product
    [Documentation]
    ...    ยืนยัน = Confirm
    ...    ยกเลิก = Cancel
    [Arguments]    ${text}
    IF    "${text}" == "Confirm"
        Click    ${DelConfirmBtn}
    ELSE
        Click    ${DelCancelBtn}
    END

Validation : No Product
    ${text}=    Get Text    //p[contains(@class, "text-slate-400")]
    Should Be True    "${text}" == "No product"

Validation : Product
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    10
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=(//div[text()="${productname}"])[1]    state=visible    timeout=1s
        IF    ${KW} == ${True}
            Click    (//div[text()="${productname}"])[1]
            BREAK
        ELSE
            Reload
        END
    END
    IF    ${KW} == ${False}
        Fail    msg=Product "${productname}" Is Not Found!!
    END

Click Products menu
    Click    ${Products}

Click Out of Stock menu
    Click    ${OutofStock}

Click Draft menu
    Click    ${Draft}

Click Ellipsis
    Click    ${Ellipsis}

Click Delete Button
    Click    ${DeleteBtn}

Click Pageback
    Click    ${PageBackBtn}
