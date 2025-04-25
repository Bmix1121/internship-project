*** Settings ***
Library     Browser
Library     FakerLibrary
Resource    ${EXECDIR}/Resource/Common/common.resource


*** Variables ***
${ContactBtn}           //button[@data-test-id="ContactBtn"]
${CancelOrderBtn}       //button[@data-test-id="CancelOrderBtn"]
${CopyOrderNumBtn}      //*[@data-test-id="OrderNumCopyBtn"]
${Pending}              //div[@data-test-id="Pending"]
${Completed}            //div[@data-test-id="Complete"]
${Canceled}             //div[@data-test-id="Cancel"]
${PageBack}             //div[@data-test-id="PageBackBtn"]
${PopupConfirmBtn}      //button[@data-test-id="ConfirmBtn"]
${PopupCancelBtn}       //button[@data-test-id="OrderCancelBtn"]
${SendBtn}              //button[@data-test-id="SendBtn"]
${MessageTxb}           //textarea[@data-test-id="MessageTxb"]
${UploadImageBtn}       //label[@data-test-id="Image_UploadBtn"]
${LoadBtn}              //button[@data-test-id="loadBtn"]
${CancelPassPopup}      //div[@data-test-id="CancelPassPopup"]
${FailPopup}            //div[@data-test-id="FailPopup"]
${ClosePopup}           //span[@data-test-id="CloseBtn"]
${CloseSheet}           //button[@data-test-id="CloseBtn"]


*** Keywords ***
Select Order
    [Arguments]    ${productname}=RobotTest
    FOR    ${i}    IN RANGE    5
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//h4[text()=" ${productname} "]    state=visible    timeout=2s
        IF    ${KW} == ${True}
            Click    //h4[contains(text(), " ${productname} ")]
            BREAK
        ELSE
            Click    ${LoadBtn}
            Scroll By    selector=//section    vertical=10000
        END
    END
    IF    ${KW} == ${False}    Fail    msg=Order "${productname}" Is Not Found!!

Validation order status
    Sleep    1s
    ${Tab}=    Get Text    //a[contains(@class, 'flex items-center') and contains(@class, 'active')]/span
    ${Text}=    Get Text    (//div[contains(@class, "right-7 absolute")]/span)[1]
    IF    "${Tab}" == "รอจัดส่ง"
        Should Be True    "${Text}" == "ที่ต้องจัดส่ง"
    ELSE IF    "${Tab}" == "สำเร็จ"
        Should Be True    "${Text}" == "สำเร็จ"
    ELSE
        Should Be True    "${Text}" == "ยกเลิก"
    END

Validation no order
    ${text}=    Get Text    //div[@class="text-center mt-4"]
    Should Be True    "${text}" == "No Order"

Validation : cancel order
    [Documentation]
    ...    ยืนยัน = Confirm
    ...    ยกเลิก = Cancel or ...
    ...    Value = ChangedMind | DeliveryTooSlow | PaymentIssue | OrderMistake
    [Arguments]    ${text}    ${Value}
    IF    "${text}" == "Confirm"
        Click    input[data-test-id="choice"][value="${Value}"]
        Click    //button[@data-test-id="CancelOrder_ConfirmBtn"]
    ELSE IF    "${text}" == "Cancel"
        Click    ${CloseSheet}
    END

Validation : if cancel order = pass
    Wait For Elements State    ${CancelPassPopup}    visible    5s
    Click    ${ClosePopup}

Validation : if cancel order = fail
    Wait For Elements State    ${FailPopup}    visible    5s
    Click    ${ClosePopup}

Validation Number of orders
    [Documentation]
    ...    Pending    =    1    :
    ...    Completed    =    2    :
    ...    Canceled    =    3
    [Arguments]    ${n}
    FOR    ${i}    IN RANGE    10
        ${loadBtncheck}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//button[@data-test-id="loadBtn"]    state=visible    timeout=2s
        IF    ${loadBtncheck} == ${True}
            Click    ${LoadBtn}
            Sleep    1s
            Scroll By    selector=//section    vertical=10000
        ELSE
            BREAK
        END
    END
    Sleep    1s
    ${status}=    Get Element Count    //div[contains(@class, 'right-7 absolute')]/span
    common.Navigate To CustomerProfile
    ${order}=    Get Text
    ...    (//div[contains(@class, "ml-7 absolute bg-orange-400")])[${n}]
    Should Be True    "${status}" == "${order}"

Send Message
    ${Message}=    FakerLibrary.Text    max_nb_chars=20
    Fill Text    ${MessageTxb}    ${Message}
    Click    ${SendBtn}
    Sleep    1s
    Wait For Elements State    //div[contains(text(),'${Message}')]    visible    2s

Upload Image
    [Arguments]    @{ImageName}
    ${Imagecount}=    Get Length    ${ImageName}
    FOR    ${i}    IN    @{ImageName}
        Sleep    1s
        Upload File By Selector    ${UploadImageBtn}    ${EXECDIR}/Data/image/${i}
    END
    FOR    ${i}    IN    1    ${Imagecount}
        Wait For Elements State    (//img[contains(@class, "max-w-xs mt-2")])[${i}]    visible    5s
        ${Imagecount}=    Evaluate    ${Imagecount}-1
    END

Required Check
    ${requiredtext}=    Get Text    //p[contains(text(), "กรุณาเลือกเหตุผลในการยกเลิก")]
    Should Be True    "${requiredtext}" == "กรุณาเลือกเหตุผลในการยกเลิก"

Select menu : Waiting for delivery
    Click    ${Pending}

Select menu : Completed
    Click    ${Completed}

Select menu : Canceled
    click    ${Canceled}

Click Cancel Order
    Click    ${CancelOrderBtn}

Click Contact Seller
    Click    ${ContactBtn}

Click Pageback
    Click    ${PageBack}

Validate Click Copy
    Sleep    1s
    Click    ${CopyOrderNumBtn}
    ${OrderNumber}=    Get Text    //div[contains(@class, "right-14 absolute overflow-hidden")]
    Click    ${ContactBtn}
    FOR    ${i}    IN RANGE    5
        Click    ${MessageTxb}
        Keyboard Key    down    key=Control
        Keyboard Key    press    key=V
        click    ${SendBtn}
        Reload
        ${MSCheck}=    Run Keyword And Return Status
        ...    Wait For Elements State    //div[text()="${OrderNumber}"]    visible    3s
        IF    ${MSCheck} == ${True}    BREAK
    END

Click Confirm Button
    [Documentation]
    ...    confirmBtn for cancel order
    Click    //button[@data-test-id="CancelOrder_ConfirmBtn"]
