*** Settings ***
Library         Browser
Variables       ${EXECDIR}/Config/config.yaml


*** Variables ***
${ProductNameTxb}           //input[@data-test-id="ProductNameTxb"]
${ImageUpload}              //label[@data-test-id="imageUploadBtn"]
${PriceTxb}                 //input[@data-test-id="PriceTxb"]
${ProductDetailTxb}         //textarea[@data-test-id="ProductDetailTxb"]
${QuantityTxb}              //input[@data-test-id="QuantityTxb"]
${Condition1}               //*[@data-test-id="Con-1-Radio"]
${Condition2}               //*[@data-test-id="Con-2-Radio"]
${PreOrderSwitch}           //*[@data-test-id="PreOrderSwitch"]/..
${PeriodTxb}                //input[@data-test-id="PeriodTxb"]
${Delivery1}                //*[@data-test-id="Delivery-1-Radio"]
${Delivery2}                //*[@data-test-id="Delivery-2-Radio"]
${ImageViewBtn}             //div[@data-test-id="Image-ViewBtn"]
${ImageDelBtn}              //div[@data-test-id="Image-DelBtn"]
${PageBackBtn}              //div[@data-test-id="PageBackBtn"]
${CloseBtn}                 //*[@data-test-id="CloseBtn"]

${ProductsMenu}             //li[@data-test-id="Products"]
${OutofStockMenu}           //li[@data-test-id="Outofstock"]
${DraftMenu}                //li[@data-test-id="Draft"]
${Ellipsis}                 //*[@data-test-id="EllipsisBtn"]
${EditBtn}                  //button[@data-test-id="EditproductBtn"]
${UpdateBtn}                //div[@data-test-id="UpdateBtn"]//button

${DraftBtn}                 //div[@data-test-id="Draft"]
${DraftPopup}               //div[@data-test-id="DraftPopup"]
${DraftConfirmBtn}          //button[@data-test-id="DraftConfirmBtn"]
${DraftCancelBtn}           //button[@data-test-id="DraftCancelBtn"]
${DraftCompletePopup}       //div[@data-test-id="DraftCompletePopup"]

${EditPopup}                //div[@data-test-id="EditPopup"]
${CancelBtn}                //button[@data-test-id="CancelBtn"]
${ConfirmBtn}               //button[@data-test-id="ConfirmBtn"]
${EditCompletePopup}        //div[@data-test-id="EditCompletePopup"]

${CancelEditPopup}          //div[@data-test-id="Cancel-Edit"]
${PagebackCancelBtn}        //button[@data-test-id="PBCancelBtn"]
${PagebackConfirmBtn}       //button[@data-test-id="PBConfirmBtn"]

${DeleteImagePopup}         //div[@data-test-id="DeleteImagePopup"]
${DelConfirmBtn}            //button[@data-test-id="DelConfirmBtn"]
${DelCancelBtn}             //button[@data-test-id="DelCancelBtn"]

${LoadBtn}                  //button[@data-test-id="loadBtn"]


*** Keywords ***
Fill Product name
    [Arguments]
    ...    ${Productname}=RobotTest_Edit
    Fill Text    ${ProductNameTxb}    ${Productname}

Upload Image
    [Documentation]
    ...    You can Input multiple [Argument]
    ...    \nEx.
    ...    \n: Upload Image :    |    Test01    |    Test02    |    Test03
    [Arguments]    @{ImageList}
    FOR    ${i}    IN    @{ImageList}
        Run Keyword And Continue On Failure
        ...    Upload File By Selector    ${ImageUpload}    ${EXECDIR}${ImagePath}${i}
    END

Fill Price
    [Arguments]
    ...    ${Price}=40
    Fill Text    ${PriceTxb}    ${Price}

Fill Product Detail
    [Arguments]
    ...    ${ProductDetail}=Edit Product Test
    Fill Text    ${ProductDetailTxb}    ${ProductDetail}

Fill Quantity
    [Arguments]
    ...    ${Quantity}=100
    Fill Text    ${QuantityTxb}    ${Quantity}

Select Conditions
    [Documentation]    InputCondition 1,2
    ...    1 = สินค้ามือหนึ่ง
    ...    2 = สินค้ามือสอง
    [Arguments]    ${InputCondition}
    IF    '${InputCondition}' == '1'
        Click    ${Condition1}
    ELSE IF    '${InputCondition}' == '2'
        Click    ${Condition2}
    END

Fill Period
    [Documentation]
    ...    Input ${Period} = ${False} If you want to Disable PreOrderSwitch Toggle Switch
    ...    And You can Input value If you want to Enable PreOrderSwitch Toggle Switch and Input value in Period Textbox
    [Arguments]
    ...    ${Period}=30
    ${isChecking}=    Run Keyword And Return Status
    ...    Wait For Elements State    selector=//input[@data-test-id='PeriodTxb']    state=visible    timeout=1s
    IF    ${Period} != ${False}
        IF    '${isChecking}' == '${False}'
            Click    ${PreOrderSwitch}
            Fill Text    ${PeriodTxb}    ${Period}
        ELSE IF    '${isChecking}' == '${True}'
            Fill Text    ${PeriodTxb}    ${Period}
        END
    ELSE IF    ${Period} == ${False}
        IF    '${isChecking}' == '${True}'    Click    ${PreOrderSwitch}
    END

Fill period test
    [Arguments]
    ...    ${Period}=21
    ${isChecking}=    Run Keyword And Return Status
    ...    Wait For Elements State    selector=//input[@data-test-id='PeriodTxb']    state=visible    timeout=1s
    IF    '${isChecking}' == '${False}'
        Click    ${PreOrderSwitch}
        Fill Text    ${PeriodTxb}    ${Period}
    ELSE IF    '${isChecking}' == '${True}'
        Fill Text    ${PeriodTxb}    ${Period}
    END

No fill Period
    [Arguments]
    ...    ${Period}=${EMPTY}
    ${isChecking}=    Run Keyword And Return Status
    ...    Wait For Elements State    selector=//input[@data-test-id='PeriodTxb']    state=visible    timeout=1s
    IF    '${isChecking}' == '${False}'
        Click    ${PreOrderSwitch}
        Fill Text    ${PeriodTxb}    ${Period}
    ELSE IF    '${isChecking}' == '${True}'
        Fill Text    ${PeriodTxb}    ${Period}
    END

Select Delivery
    [Documentation]    InputDelivery 1,2
    ...    1 = รับที่บริษัท
    ...    2 = อื่นๆ
    [Arguments]    ${InputDelivery}
    IF    '${InputDelivery}' == '1'
        Click    ${Delivery1}
    ELSE IF    '${InputDelivery}' == '2'
        Click    ${Delivery2}
    END

Validation : fill price , fill quantity , fill period
    [Documentation]
    ...    กรุณากรอกข้อมูลให้ถูกต้อง    :
    ...    กรุณากรอกข้อมูลเป็นตัวเลขเท่านั้น    :
    [Arguments]    ${Inputtext}
    ${text}=    Get Text    //p[@class="text-red-500 text-sm"]
    Should Be True    "${text}" == "*** ${Inputtext} ***"

Validation : upload image
    [Documentation]
    ...    อัปโหลดไฟล์ได้ไม่เกิน 10 MB    :
    ...    กรุณาอัปโหลดไฟล์ที่เป็นรูปภาพเท่านั้น    :
    ...    อัปโหลดรูปภาพได้ไม่เกิน 5 รูป    :
    [Arguments]    ${Inputtext}
    ${text}=    Get Text    //p[@class="text-red-500 text-sm"]
    Should Be True    "${text}" == "*** ${Inputtext} ***"

Required check
    [Documentation]
    ...    กรุณากรอกชื่อสินค้า    :
    ...    กรุณาเพิ่มรูปภาพสินค้า    :
    ...    กรุณากรอกราคาสินค้า    :
    ...    กรุณากรอกจำนวนสินค้า    :
    ...    กรุณาเลือกประเภทสินค้า    :
    ...    กรุณากรอกระยะเวลา    :
    ...    กรุณาเลือกการส่งสินค้า    :
    [Arguments]    ${Inputtext}
    ${Text}=    Get Text    //p[contains(@class, 'text-red-500 text-sm')]
    Should Be True    "${Text}" == "*** ${Inputtext} ***"

Upload image test
    [Documentation]
    ...    1 = 1 image    :
    ...    5 = 5 image    :
    ...    6 = 6 image
    [Arguments]    ${n}
    IF    ${n} == 1
        Fill Productname
        Upload Image    A.jpg
        Fill Price
        Fill Product Detail
        Fill Quantity
        Select Conditions    สินค้ามือหนึ่ง
        Fill Period
        Select Delivery    รับที่บริษัท
    ELSE IF    ${n} == 5
        Fill Productname
        Upload Image    cap.jpg    glasses.jpg    hoodie.jpg    sneakers.jpg
        Fill Price
        Fill Product Detail
        Fill Quantity
        Select Conditions    สินค้ามือหนึ่ง
        Fill Period
        Select Delivery    รับที่บริษัท
    ELSE IF    ${n} == 6
        Fill Productname
        Upload Image    glasses.jpg    hoodie.jpg    sneakers.jpg    watch.jpg    phone.jpg
        Fill Price
        Fill Product Detail
        Fill Quantity
        Select Conditions    สินค้ามือหนึ่ง
        Fill Period
        Select Delivery    รับที่บริษัท
    END

Validation : Product
    [Arguments]    ${productname}=RobotTest_Edit
    FOR    ${i}    IN RANGE    10
        ${KW}=    Run Keyword And Return Status
        ...    Wait For Elements State    selector=//div[text()="${productname}"]    state=visible    timeout=2s
        IF    ${KW} == ${True}
            Click    //div[text()="${productname}"]
            BREAK
        ELSE
            Reload
        END
    END
    IF    ${KW} == ${False}
        Fail    msg=Product "${productname}" Is Not Found!!
    END

Validation : Edit Product
    [Documentation]
    ...    ยืนยัน = Confirm    :
    ...    ยกเลิก = Cancel or ...    :
    ...    กรณีแก้ไขสินค้าไม่ถูกต้อง = Fail
    [Arguments]    ${text}
    IF    "${text}" == "Confirm"
        Click    ${ConfirmBtn}
        Wait For Elements State    ${EditCompletePopup}    visible    5s
        CLick Close Popup Button
    ELSE IF    "${text}" == "Fail"
        Click    ${ConfirmBtn}
    ELSE
        Click    ${CancelBtn}
    END

Validation : Draft Product
    [Documentation]
    ...    ยืนยัน = Confirm    :
    ...    ยกเลิก = Cancel or ...
    [Arguments]    ${text}
    IF    "${text}" == "Confirm"
        Click    ${DraftConfirmBtn}
        Wait For Elements State    ${DraftCompletePopup}    visible    5s
        CLick Close Popup Button
    ELSE
        Click    ${DraftCancelBtn}
    END

Validation : Pageback
    [Documentation]
    ...    ยืนยัน = Confirm    :
    ...    ยกเลิก = Cancel or ...
    [Arguments]    ${text}
    IF    "${text}" == "Confirm"
        Click    ${PagebackConfirmBtn}
    ELSE
        Click    ${PagebackCancelBtn}
    END

Validation : No Product
    ${text}=    Get Text    //p[contains(@class, "text-slate-400")]
    Should Be True    "${text}" == "No product"

Validation : Delete Image
    ${text}=    Get Text    //p[contains(@class, "text-red-500 text-sm")]
    Should Be True    "${text}" == "*** กรณีต้องการลบรูปภาพเก่าจำเป็นต้องมีรูปภาพใหม่และ Update สินค้าก่อน ***"

View image
    ${count}=    Get Element Count    selector=//div[@data-test-id="Image-ViewBtn"]
    FOR    ${i}    IN RANGE    1    ${count}+1
        Click    (//div[@data-test-id="Image-ViewBtn"])[${i}]
        Click    ${CloseBtn}
    END

Delete image
    ${count}=    Get Element Count    selector=//div[@data-test-id="Image-DelBtn"]
    FOR    ${i}    IN RANGE    ${count}
        Wait For Elements State    (//div[@data-test-id="Image-DelBtn"])[${count}]    visible    5s
        Click    (//div[@data-test-id="Image-DelBtn"])[${count}]
        Wait For Elements State    ${DeleteImagePopup}    visible    5s
        Click    ${DelConfirmBtn}
        ${count}=    Evaluate    ${count}-1
    END
    Sleep    1s

Click pageback
    Click    ${PageBackBtn}

Click Products menu
    Click    ${ProductsMenu}

Click Out of Stock menu
    Click    ${OutofStockMenu}

Click Draft menu
    Click    ${DraftMenu}

CLick Ellipsis
    Wait For Elements State    selector=//div[text()="RobotTest"]    state=visible    timeout=1s
    Click    ${Ellipsis}
    Wait For Elements State    //div[contains(@class,"absolute right-0 w-28")]    visible    5s

Click Edit Button
    Click    ${EditBtn}
    Sleep    1s

CLick Update Button
    Click    ${UpdateBtn}

CLick Close Popup Button
    Click    ${CloseBtn}

CLick Draft Button
    Click    ${DraftBtn}
