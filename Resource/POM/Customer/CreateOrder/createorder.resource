*** Settings ***
Library     Browser


*** Variables ***
${BuyBtn}           //button[@data-test-id="BuyBtn"]
${Quantity1}        //button[@data-test-id="Quantity_1"]
${Quantity2}        //button[@data-test-id="Quantity_2"]
${BuyNowBtn}        //button[@data-test-id="BuyNowBtn"]

${PointRadio}       input[data-test-id="Payment"][value="1"]
${CODRadio}         input[data-test-id="Payment"][value="2"]
${Receive1}         input[data-test-id="Receive"][value="1"]
${Receive2}         input[data-test-id="Receive"][value="2"]
${NoteTxb}          //*[@data-test-id="NoteTxb"]

${OrderNowBtn}      //button[@data-test-id="OrderNowBtn"]
${CompletePopup}    //div[@data-test-id="CompletePopup"]
${CloseBtn}         //button[@data-test-id="CloseBtn"]
${PageBackBtn}      //*[@data-test-id="PageBackBtn"]
${LoadBtn}          //button[@data-test-id="loadBtn"]

${OrderPopup}       //div[@data-test-id="OrderPopup"]
${ConfirmBtn}       //button[@data-test-id="OrderConfirmBtn"]
${CancelBtn}        //button[@data-test-id="OrderCancelBtn"]


*** Keywords ***
Select Product
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    10
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//div[text()="${productname}"]    state=visible    timeout=0.8s
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

Choose Quantity
    [Documentation]    จำนวนสินค้า
    ...    Quantity1 = "ลด"
    ...    Quantity2 = "เพิ่ม"
    [Arguments]    ${Quantity}    ${count}
    IF    '${Quantity}' == 'เพิ่ม'
        ${n}=    Get Text    selector=//span[@class="mx-2 text-xl"]
        Click With Options    ${Quantity2}    clickCount=${count}
        ${sum}=    Evaluate    ${n}+${count}
        ${n2}=    Get Text    selector=//span[@class="mx-2 text-xl"]
        Should Be True    condition=${sum} == ${n2}
    ELSE IF    '${Quantity}' == 'ลด'
        ${n}=    Get Text    selector=//span[@class="mx-2 text-xl"]
        Click With Options    ${Quantity1}    clickCount=${count}
        ${sum}=    Evaluate    ${n}-${count}
        ${n2}=    Get Text    selector=//span[@class="mx-2 text-xl"]
        Should Be True    condition=${sum} == ${n2}
    END

Choose Quantity2
    ${Text}=    Get Text    //div[contains(@class, "app-text-secondary w-64")]
    ${KW}=    Run Keyword And Return Status
    ...    Should Be True    " ${Text} " == " / 0 item available "
    FOR    ${i}    IN RANGE    10
        IF    '${KW}' == '${False}'
            Click With Options    ${Quantity2}    clickCount=50
            ${Text}=    Get Text    //div[contains(@class, "app-text-secondary w-64")]
            ${KW}=    Run Keyword And Return Status
            ...    Should Be True    " ${Text} " == " / 0 item available "
        ELSE IF    '${kw}' == '${True}'
            BREAK
        END
    END

Select Payment
    [Documentation]    การชำระเงิน
    ...    "point" = PointRadio
    ...    "ปลายทาง" = CODRadio
    [Arguments]    ${Payment}
    IF    '${Payment}' == 'point'
        Click    ${PointRadio}
    ELSE IF    '${Payment}' == 'ปลายทาง'
        Click    ${CODRadio}
    END

Select Receive
    [Documentation]    การรับสินค้า
    ...    "รับที่ตึก2" = Receive1
    ...    "นัดรับ" = Receive2
    [Arguments]    ${inputReceive}
    IF    '${inputReceive}' == 'รับที่ตึก2'
        Click    ${Receive1}
    ELSE IF    '${inputReceive}' == 'นัดรับ'
        Click    ${Receive2}
    END

Fill Note
    [Arguments]    ${InputNote}=Create Order by Robot
    Fill Text    ${NoteTxb}    ${InputNote}

Validation : create order
    Wait For Elements State    ${CompletePopup}    visible    timeout=5s
    Click    //span[@data-test-id="CloseBtn"]

Validation : Out Of Stock
    Wait For Elements State    //div[@data-test-id="OutofStockPopup"]
    Click    //span[@data-test-id="CloseBtn"]

Required Check
    [Documentation]
    ...    payment | receive | point
    [Arguments]    ${required}
    IF    '${required}' == 'payment'
        ${requiredtext}=    Get Text    //p[@class="text-red-500 text-sm"]
        Should Be True    "${requiredtext}" == "กรุณาเลือกวิธีชำระเงิน"
    ELSE IF    '${required}' == 'receive'
        ${requiredtext}=    Get Text    //p[@class="text-red-500 text-sm"]
        Should Be True    "${requiredtext}" == "กรุณาเลือกวิธีการรับสินค้า"
    ELSE IF    "${required}" == "point"
        ${requiredtext}=    Get Text    //p[@class="text-red-500 text-sm"]
        Should Be True    "${requiredtext}" == "กรุณาเติมPoint"
    END

Click Buy
    Click    ${BuyBtn}

Click BuyNow
    Click    ${BuyNowBtn}

Click PageBack Button
    Sleep    0.5s
    Click    ${PageBackBtn}

Click Close Button
    Click    ${CloseBtn}

Click OrderNow
    Click    ${OrderNowBtn}
    Wait For Elements State    ${OrderPopup}    visible    5s

Click Confirm / Cancel Button
    [Arguments]    ${text}
    IF    "${text}" == "Confirm"
        Click    ${ConfirmBtn}
    ELSE IF    "${text}" == "Cancel"
        Click    ${CancelBtn}
    END
