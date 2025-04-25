*** Settings ***
Library     Browser
Library     String
Resource    ${EXECDIR}/Resource/Common/common.resource


*** Variables ***
${ToShipMenu}           //div[@data-test-id="ToShip"]
${CanceledMenu}         //div[@data-test-id="Canceled"]
${HistoryMenu}          //div[@data-test-id="Sell_History"]

${ShippedBtn}           //button[@data-test-id="ShippedBtn"]
${ShippedPopup}         //div[@data-test-id="ShippedPopup"]
${ShipConfirmBtn}       //button[@data-test-id="ConfirmBtn"]
${ShipCancelBtn}        //button[@data-test-id="CancelBtn"]

${PageBack}             //div[@data-test-id="PageBackBtn"]
${LoadBtn}              //button[@data-test-id="loadBtn"]
${CancelOrderBtn}       //button[@data-test-id="CancelOrderBtn"]
${CloseSheet}           //button[@data-test-id="CloseBtn"]
${ClosePopup}           //span[@data-test-id="CloseBtn"]

${DeliPassPopup}        //div[@data-test-id="DeliPassPopup"]
${CancelPassPopup}      //div[@data-test-id="CancelPassPopup"]
${FailPopup}            //div[@data-test-id="FailPopup"]


*** Keywords ***
Validation : No Order
    Sleep    0.5s
    ${text}    Get Text    //div[@class="text-center mt-4"]
    Should Be True    "${text}" == "No Order"

Validation : Delivery
    [Documentation]
    ...    Confirm    or    Cancel
    [Arguments]    ${text}
    IF    "${text}" == "Confirm"
        Click    ${ShipConfirmBtn}
    ELSE
        Click    ${ShipCancelBtn}
    END

Validation : if delivery = pass
    Wait For Elements State    ${DeliPassPopup}    visible    5s
    Click    ${ClosePopup}

Validation : if delivery = fail
    Wait For Elements State    ${FailPopup}    visible    5s
    Click    ${ClosePopup}

Validation : number of order and order status
    [Documentation]
    ...    ที่ต้องจัดส่ง    |    สำเร็จ    |    ยกเลิก
    [Arguments]    ${InputOrderStatus}
    Sleep    1s
    IF    "${InputOrderStatus}" == "ที่ต้องจัดส่ง"
        ${OutsiteCount}    Get Text    (//div[contains(@class, "text-3xl pt-4")])[1]
        Click To Ship menu
    ELSE IF    "${InputOrderStatus}" == "สำเร็จ"
        Click history
    ELSE
        ${OutsiteCount}    Get Text    (//div[contains(@class, "text-3xl pt-4")])[2]
        Click canceled menu
    END

    FOR    ${i}    IN RANGE    10
        Sleep    1s
        ${loadBtncheck}    Run Keyword And Return Status
        ...    Wait For Elements State    selector=${LoadBtn}    state=visible    timeout=1s
        IF    ${loadBtncheck} == ${True}
            Click    ${LoadBtn}
            Scroll By    selector=//section    vertical=10000
        ELSE
            BREAK
        END
    END

    ${HeaderCount}    Get Text    (//div[contains(@class, "text-2xl")])[2]
    @{HeaderCount}    String.Split String    string=${HeaderCount}    separator=${SPACE}    max_split=1
    ${HeaderCount}    Evaluate    "${HeaderCount}[1]".replace('(', '').replace(')', '')
    ${ElementCount}    Get Element Count
    ...    //div[contains(@class, "right-7 absolute")]/span
    IF    "${InputOrderStatus}" == "สำเร็จ"
        Should Be True    "${ElementCount}" == "${HeaderCount}"
    ELSE
        Should Be True    "${ElementCount}" == "${HeaderCount}" == "${OutsiteCount}"
    END

Select Order
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    5
        ${KW}    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//h4[text()=" ${productname} "]    state=visible    timeout=1s
        IF    ${KW} == ${True}
            Click    //h4[text()=" ${productname} "]
            BREAK
        ELSE
            Click    ${LoadBtn}
            Scroll By    selector=//section    vertical=10000
        END
    END
    IF    ${KW} == ${False}    Fail    msg=Order "${productname}" Is Not Found!!

Validation : cancel order
    [Documentation]
    ...    ยืนยัน = Confirm    :
    ...    ยกเลิก = Cancel or ...    |
    ...    Value = OutofStock | UnabletoContactCustomer
    [Arguments]    ${text}    ${Value}
    IF    "${text}" == "Confirm"
        Click    input[data-test-id="choice"][value="${Value}"]
        Click    //button[@data-test-id="CancelOrder_ConfirmBtn"]
    ELSE
        Click    ${CloseSheet}
    END

Required Check
    ${requiredtext}    Get Text    //p[contains(text(), "กรุณาเลือกเหตุผลในการยกเลิก")]
    Should Be True    "${requiredtext}" == "กรุณาเลือกเหตุผลในการยกเลิก"

Validation : if cancel order = pass
    Wait For Elements State    ${CancelPassPopup}    visible    5s
    Click    ${ClosePopup}

Validation : if cancel order = fail
    Wait For Elements State    ${FailPopup}    visible    5s
    Click    ${ClosePopup}

CLick Delivery
    Scroll To Element    ${ShippedBtn}
    Click    ${ShippedBtn}
    Wait For Elements State    ${ShippedPopup}    visible    timeout=5s

CLick To Ship menu
    Click    ${ToShipMenu}

Click history
    Click    ${HistoryMenu}

Click canceled menu
    Click    ${CanceledMenu}

Click page back
    Click    ${PageBack}

Click Cancel Order
    Click    ${CancelOrderBtn}

Click Confirm Button
    [Documentation]
    ...    confirmBtn for cancel order
    Click    //button[@data-test-id="CancelOrder_ConfirmBtn"]
